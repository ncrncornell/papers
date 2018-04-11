    @{group@
    @?groupkey@<div class="h3NoToc papercite">@groupkey@</div>@;groupkey@
    <ul class="papercite_bibliography">
     @{entry@ <li>
    	@#entry@<br/>
        @?abstract@ <a href="javascript:void(0)" id="papercite_abstract_@papercite_id@" class="papercite_toggle">[Abstract]</a> @;abstract@
        @?comment@ <a href="javascript:void(0)" id="papercite_comment_@papercite_id@" class="papercite_toggle">[Notes]</a> @;comment@
     	@?pdf@ <a href="@pdf@" title='Download PDF' class='papercite_pdf'>[PDF]</a>@;pdf@
	@?doi@<a href='http://dx.doi.org/@doi@' class='papercite_doi' title='View document on publisher site'>[DOI]</a>@;doi@
	@?url@<a href='@url@' class='papercite_url' title='View document on publisher site'>[URL]</a>@;url@
	 <a href="javascript:void(0)" id="papercite_@papercite_id@" class="papercite_toggle">[Bibtex]</a>
        @?abstract@
        <blockquote class="papercite_bibtex" id="papercite_abstract_@papercite_id@_block">@abstract@</blockquote>
        @;abstract@
        @?comment@
        <blockquote class="papercite_bibtex" id="papercite_comment_@papercite_id@_block">@comment@</blockquote>
        @;comment@
	 <div class="papercite_bibtex" id="papercite_@papercite_id@_block"><pre><code class="tex bibtex">@bibtex@</code></pre></div>
        </li>
     @}entry@
    </ul>
    @}group@
