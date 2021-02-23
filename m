Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B43E3231ED
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 21:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhBWUM7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 15:12:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233363AbhBWUMa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 15:12:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E88EA64E6B;
        Tue, 23 Feb 2021 20:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614111109;
        bh=V7jGgaTvePLnhzX3IQJRxGgf0qmrmtHMEb1eydTPlpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVBxku+ZS7e5oVm8i9uCYBS8TafOUM1B4jKGo7qNqsLdjEjvUQa8QLyx1bqPd+5mm
         6O4uFRlLLHBagADxj4zWhrJVsBSxPKWdEyTebOHjNcZjtjFBhg9SohXlfZ7G5kDAB5
         GMOeYBDapkfcce5BA1pic7YUD0W/2mtVGgTlLVd2SBTQCvih5Z4FmRGl4hOCY02z67
         8H36If1ygaJsO8z2J8vvAZJowjOCJfsXGopt/qLmpKS0z+b362QAbyH2aBLiDm3xss
         cRzXkL63gl6efSH5AhMQKFN5ZOpZQJJn1Phuk4ujDfFLbaSknhrqCOyrefPSJDKnBD
         KOMVx3OhLOD4Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id CDBFD40CD9; Tue, 23 Feb 2021 17:11:44 -0300 (-03)
Date:   Tue, 23 Feb 2021 17:11:44 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: [PATCH] perf-probe: dso: Add symbols in .text.* subsections to
 text symbol map in kenrel modules
Message-ID: <YDVhgENpshYqDqiO@kernel.org>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
 <161406587251.969784.5469149622544499077.stgit@devnote2>
 <00abcbd4-e2c2-a699-8eb5-f8804035b46e@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00abcbd4-e2c2-a699-8eb5-f8804035b46e@virtuozzo.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Em Tue, Feb 23, 2021 at 06:02:58PM +0300, Evgenii Shatokhin escreveu:
> On 23.02.2021 10:37, Masami Hiramatsu wrote:
> > The kernel modules have .text.* subsections such as .text.unlikely.
> > Since dso__process_kernel_symbol() only identify the symbols in the ".text"
> > section as the text symbols and inserts it in the default dso in the map,
> > the symbols in such subsections can not be found by map__find_symbol().
> > 
> > This adds the symbols in those subsections to the default dso in the map so
> > that map__find_symbol() can find them. This solves the perf-probe issue on
> > probing online module.
> > 
> > Without this fix, probing on a symbol in .text.unlikely fails.
> >    ----
> >    # perf probe -m nf_conntrack nf_l4proto_log_invalid
> >    Probe point 'nf_l4proto_log_invalid' not found.
> >      Error: Failed to add events.
> >    ----
> > 
> > With this fix, it works because map__find_symbol() can find the symbol
> > correctly.
> >    ----
> >    # perf probe -m nf_conntrack nf_l4proto_log_invalid
> >    Added new event:
> >      probe:nf_l4proto_log_invalid (on nf_l4proto_log_invalid in nf_conntrack)
> > 
> >    You can now use it in all perf tools, such as:
> > 
> >    	perf record -e probe:nf_l4proto_log_invalid -aR sleep 1
> > 
> >    ----
> > 
> > Reported-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> Thanks for the fix!
> 
> It looks like it helps, at least with nf_conntrack in kernel 5.11:

So I'm taking this as you providing a:

Tested-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>

ok?

- Arnaldo

> ---------------------
> # ./perf probe -v -m nf_conntrack nf_ct_resolve_clash
> probe-definition(0): nf_ct_resolve_clash
> symbol:nf_ct_resolve_clash file:(null) line:0 offset:0 return:0 lazy:(null)
> 0 arguments
> Failed to get build-id from nf_conntrack.
> Cache open error: -1
> Open Debuginfo file:
> /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
> Try to find probe point from debuginfo.
> Matched function: nf_ct_resolve_clash [33616]
> Probe point found: nf_ct_resolve_clash+0
> Found 1 probe_trace_events.
> Opening /sys/kernel/tracing//kprobe_events write=1
> Opening /sys/kernel/tracing//README write=0
> Writing event: p:probe/nf_ct_resolve_clash
> nf_conntrack:nf_ct_resolve_clash+0
> Added new event:
>   probe:nf_ct_resolve_clash (on nf_ct_resolve_clash in nf_conntrack)
> 
> You can now use it in all perf tools, such as:
> 
>         perf record -e probe:nf_ct_resolve_clash -aR sleep 1
> ---------------------
> 
> I guess, the patch is suitable for stable kernel branches as well.
> 
> Without the patch, the workaround you suggested earlier (using the full path
> to nf_conntrack.ko) works too.
> 
> > ---
> >   tools/perf/util/symbol-elf.c |    4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> > index 6dff843fd883..0c1113236913 100644
> > --- a/tools/perf/util/symbol-elf.c
> > +++ b/tools/perf/util/symbol-elf.c
> > @@ -985,7 +985,9 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
> >   	if (strcmp(section_name, (curr_dso->short_name + dso->short_name_len)) == 0)
> >   		return 0;
> > -	if (strcmp(section_name, ".text") == 0) {
> > +	/* .text and .text.* are included in the text dso */
> > +	if (strncmp(section_name, ".text", 5) == 0 &&
> > +	    (section_name[5] == '\0' || section_name[5] == '.')) {
> >   		/*
> >   		 * The initial kernel mapping is based on
> >   		 * kallsyms and identity maps.  Overwrite it to
> > 
> > .
> > 
> 
> Regards,
> Evgenii

-- 

- Arnaldo
