    @{group@
    @?groupkey@<h3 class="papercite">@groupkey@</h3>@;groupkey@
    <ul class="papercite_bibliography">
     @{entry@ <li>
    	@#entry@<br/>
     	@?pdf@ <a href="@pdf@" title='Download PDF' class='papercite_pdf'>[PDF]</a>@;pdf@
	@?doi@<a href='http://dx.doi.org/@doi@' class='papercite_doi' title='View document on publisher site'>[DOI]</a>@;doi@
	@?url@<a href='@url@' class='papercite_url' title='View document on publisher site'>[URL]</a>@;url@
	 <a href="javascript:void(0)" id="papercite_@papercite_id@" class="papercite_toggle">[Bibtex]</a>
	 <div class="papercite_bibtex" id="papercite_@papercite_id@_block"><pre><code class="tex bibtex">@bibtex@</code></pre></div>
        </li>
     @}entry@
    </ul>
    @}group@
