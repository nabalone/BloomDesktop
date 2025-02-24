﻿using System.ComponentModel;
using System.IO;
using Bloom.Publish;
using Bloom.Publish.PDF;
using NUnit.Framework;
using SIL.IO;

namespace BloomTests
{
	[TestFixture]
#if __MonoCS__
	[Apartment(System.Threading.ApartmentState.STA)]
#endif
	[NUnit.Framework.Category("RequiresUI")]
	public class PdfMakerTests
	{
		[Test]
		public void MakePdf_BookStyleIsNone_OutputsPdf()
		{
			var maker = new PdfMaker();
			using (var input = TempFile.WithExtension("html"))
			using (var output = new TempFile())
			{
				File.WriteAllText(input.Path, "<html><body>Hello</body></html>");
				File.Delete(output.Path);
				RunMakePdf(maker, input.Path, output.Path, "A5", false, false, false,
					PublishModel.BookletLayoutMethod.SideFold, PublishModel.BookletPortions.AllPagesNoBooklet);
				//we don't actually have a way of knowing it did a booklet
				Assert.IsTrue(File.Exists(output.Path), "Failed to convert trivial HTML file to PDF (AllPagesNoBooklet)");
				var bytes = File.ReadAllBytes(output.Path);
				Assert.Less(1000, bytes.Length, "Generated PDF file is way too small! (AllPagesNoBooklet)");
				Assert.IsTrue (bytes [0] == (byte)'%' && bytes [1] == (byte)'P' && bytes [2] == (byte)'D' && bytes [3] == (byte)'F',
					"Generated PDF file started with the wrong 4-byte signature (AllPagesNoBooklet)");
			}
		}

		[Test]
		public void MakePdf_BookStyleIsBooklet_OutputsPdf()
		{
			var maker = new PdfMaker();
			using (var input = TempFile.WithExtension("html"))
			using (var output = new TempFile())
			{
				File.WriteAllText(input.Path, "<html><body>Hello</body></html>");
				File.Delete(output.Path);
				RunMakePdf(maker, input.Path, output.Path, "A5", false, false, false,
					PublishModel.BookletLayoutMethod.SideFold, PublishModel.BookletPortions.BookletPages);
				//we don't actually have a way of knowing it did a booklet
				Assert.IsTrue(File.Exists(output.Path), "Failed to convert trivial HTML file to PDF (BookletPages)");
				var bytes = File.ReadAllBytes(output.Path);
				Assert.Less(1000, bytes.Length, "Generated PDF file is way too small! (BookletPages)");
				Assert.IsTrue (bytes [0] == (byte)'%' && bytes [1] == (byte)'P' && bytes [2] == (byte)'D' && bytes [3] == (byte)'F',
					"Generated PDF file started with the wrong 4-byte signature (BookletPages)");
			}
		}

		/// <summary>
		/// This tests for a regretion on BL-81, BL-96, BL-76; wkhtmltopdf itself couldn't handle file names anything up out of ascii-land
		/// </summary>
		[Test]
		public void MakePdf_BookNameIsChinese_OutputsPdf()
		{
			var maker = new PdfMaker();
			using (var input = TempFile.WithFilename("北京.html"))
			using (var output = TempFile.WithFilename("北京.pdf"))
			{
				RobustFile.WriteAllText(input.Path, "<html><body>北京</body></html>");
				RobustFile.Delete(output.Path);
				RunMakePdf(maker, input.Path, output.Path, "A5", false, false, false,
					PublishModel.BookletLayoutMethod.SideFold, PublishModel.BookletPortions.BookletPages);
				//we don't actually have a way of knowing it did a booklet
				Assert.IsTrue(File.Exists(output.Path), "Failed to convert trivial HTML file to PDF (Chinese filenames and content)");
				var bytes = File.ReadAllBytes(output.Path);
				Assert.Less(1000, bytes.Length, "Generated PDF file is way too small! (Chinese filenames and content)");
				Assert.IsTrue (bytes [0] == (byte)'%' && bytes [1] == (byte)'P' && bytes [2] == (byte)'D' && bytes [3] == (byte)'F',
					"Generated PDF file started with the wrong 4-byte signature (Chinese filenames and content)");
			}
		}

		[Test]
		public void MakePdf_BookNameIsNonAscii_OutputsPdf()
		{
			var maker = new PdfMaker();
			using (var input = TempFile.WithFilename("എന്റെ ബുക്ക്.html"))
			using (var output = TempFile.WithFilename("എന്റെ ബുക്ക്.pdf"))
			{
				File.WriteAllText(input.Path, "<META HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=utf-8\"><html><body>എന്റെ ബുക്ക്</body></html>");
				File.Delete(output.Path);
				RunMakePdf(maker, input.Path, output.Path, "A5", false, false, false,
					PublishModel.BookletLayoutMethod.SideFold, PublishModel.BookletPortions.BookletPages);
				//we don't actually have a way of knowing it did a booklet
				Assert.IsTrue(File.Exists(output.Path), "Failed to convert trivial HTML file to PDF (Indic script filenames and content)");
				var bytes = File.ReadAllBytes(output.Path);
				Assert.Less(1000, bytes.Length, "Generated PDF file is way too small! (Indic script filenames and content)");
				Assert.IsTrue (bytes [0] == (byte)'%' && bytes [1] == (byte)'P' && bytes [2] == (byte)'D' && bytes [3] == (byte)'F',
					"Generated PDF file started with the wrong 4-byte signature (Indic script filenames and content)");
			}
		}

		/// <summary>
		/// Runs PdfMaker.MakePdf() with the desired arguments.  Note that the implementation (as of March 2015)
		/// uses an external program to generate the PDF from the HTML file, so it doesn't need to be run on
		/// a background thread.  The process includes a (possibly overgenerous) timeout, so we don't try to
		/// impose one here.
		/// </summary>
		/// <remarks>
		/// Running this on a background thread would be okay, except that on Linux, the interaction between
		/// Mono and NUnit and the Bloom method result in the BackgroundWorker.RunWorkerCompleted event
		/// never being fired if tests other than those in this file are run along with these tests.  This is
		/// almost certainly an obscure bug in Mono.  Running the method directly as we do here sidesteps that
		/// problem.  (See https://jira.sil.org/browse/BL-831.)
		/// </remarks>
		void RunMakePdf(PdfMaker maker, string input, string output, string paperSize, bool landscape, bool saveMemoryMode, bool rightToLeft,
			PublishModel.BookletLayoutMethod layout, PublishModel.BookletPortions portion)
		{
			// Passing in a DoWorkEventArgs object prevents a possible exception being thrown.  Which may not
			// really matter much in the test situation since NUnit would catch the exception.  But I'd rather
			// have a nice test failure message than an unexpected exception caught message.
			var eventArgs = new DoWorkEventArgs(null);
			maker.MakePdf(new PdfMakingSpecs()
			{
				InputHtmlPath = input,
				OutputPdfPath = output,
				PaperSizeName = paperSize,
				Landscape = landscape,
				SaveMemoryMode = saveMemoryMode,
				LayoutPagesForRightToLeft = rightToLeft,
				BooketLayoutMethod = layout,
				BookletPortion = portion
			},null, eventArgs, null);
		}
	}
}
