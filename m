Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189832266F
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 08:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBWHhk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 02:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhBWHhj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 02:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22CD64E3F;
        Tue, 23 Feb 2021 07:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614065818;
        bh=7gJIour+9iSphku85BgGDnhvooMHGGe1uyD7qHYDrJw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7117lrxERjI0fa7LbM61S5YkfRD+XrwXCBf1LPtwAOOtClh96aFev0LE4rVahIDP
         4qjyOhvdTjB7aBY4/acWptlkrmXJQo866y+nzmoQyWfx1oSzTTPNoZyC3snT6caWJH
         fad+JWFlX2WhGrbJ7OJgG2IikcAEtaErrgzNrcucTbaPAgsFJ6nLC100INzV4hJFvr
         Chk3iO4lzuH9nHY/wRho9csfjMpoBsiHUIK5Pktjyl3wgwGNwDtuuSifA6Khf3SpFJ
         B6DztGO6aIAZNbKae45nZChIzHDE5QguZfO9tHzl7XQSv0onNPBhRN/af8hRp+dkyF
         4F6d1kCATcmcw==
Date:   Tue, 23 Feb 2021 16:36:53 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: [PATCH] perf-probe: Failback to symbol-base probe for probes on
 module
Message-Id: <20210223163653.e7cf141d207ba07576d95f59@kernel.org>
In-Reply-To: <161404491047.941247.11308029534557469716.stgit@devnote2>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
        <161404491047.941247.11308029534557469716.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Please ignore this. I will send a better fix.

Thanks,

On Tue, 23 Feb 2021 10:48:30 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> If an error occurs on post processing (this converts probe point to
> _text relative address for identifying non-unique symbols) for the
> probes on module, failback to symbol-base probe.
> 
> There are many non-unique name symbols (local static functions can
> be in the different name spaces) in the kernel. If perf-probe uses
> a symbol-based probe definition, it can be put on an unintended
> symbol. To avoid such mistake, perf-probe tries to convert the
> address to the _text relative address expression.
> 
> However, such symbol duplication is rare for only one module. Thus
> even if the conversion fails, perf probe can failback to the symbol
> based probe.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  tools/perf/util/probe-event.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index a9cff3a50ddf..af946f68e32e 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -779,16 +779,16 @@ post_process_module_probe_trace_events(struct probe_trace_event *tevs,
>  
>  	map = get_target_map(module, NULL, false);
>  	if (!map || debuginfo__get_text_offset(dinfo, &text_offs, true) < 0) {
> -		pr_warning("Failed to get ELF symbols for %s\n", module);
> -		return -EINVAL;
> +		pr_info("NOTE: Failed to get ELF symbols for %s. Use symbol based probe.\n", module);
> +		return 0;
>  	}
>  
>  	mod_name = find_module_name(module);
>  	for (i = 0; i < ntevs; i++) {
> -		ret = post_process_probe_trace_point(&tevs[i].point,
> -						map, (unsigned long)text_offs);
> -		if (ret < 0)
> -			break;
> +		if (post_process_probe_trace_point(&tevs[i].point,
> +				map, (unsigned long)text_offs) < 0)
> +			pr_info("NOTE: %s is not in the symbol map. Use symbol based probe.\n",
> +				   tevs[i].point.symbol);
>  		tevs[i].point.module =
>  			strdup(mod_name ? mod_name : module);
>  		if (!tevs[i].point.module) {
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
