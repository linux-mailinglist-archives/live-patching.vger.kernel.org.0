Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4B3223D7
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 02:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBWBtT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 20:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhBWBtR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 20:49:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AB064DEC;
        Tue, 23 Feb 2021 01:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614044915;
        bh=Wd9V4OSrxLHfWkTWdrluJq+CUTtT0e4FlM31R7l6+CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gny6Cj3Uzk5u3VlVGwP0t1ON3Hbnbirl636tgpS6NPJndMTjX6ELHboVDND0PTYRS
         DHmwOX+39AfNCfS905UUliv6x74+/jDWZl/L2HN3KN7FrXM3IOHmjuLEOYwy1IirAX
         WZAPc4OhdTWuU4dFo0/UxhGxkMd/leHxSJ9ot7/jJjU8RuHOZpv8uX/bodDkvm6xMp
         xxMDBmuRi7wF6gkPdeyUM1AM5jYvUSSrwNfrxoZ7v5oNKAnG5mWXIox+cRaFHyneLK
         q7NJmBNt3XNkJq0PRvZurVdkSAieTS/gHRNHQdPwzLGkREs1Lf6pTCYMi1l61SX69L
         LoWF34kB6JQ9A==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH] perf-probe: Failback to symbol-base probe for probes on module
Date:   Tue, 23 Feb 2021 10:48:30 +0900
Message-Id: <161404491047.941247.11308029534557469716.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

If an error occurs on post processing (this converts probe point to
_text relative address for identifying non-unique symbols) for the
probes on module, failback to symbol-base probe.

There are many non-unique name symbols (local static functions can
be in the different name spaces) in the kernel. If perf-probe uses
a symbol-based probe definition, it can be put on an unintended
symbol. To avoid such mistake, perf-probe tries to convert the
address to the _text relative address expression.

However, such symbol duplication is rare for only one module. Thus
even if the conversion fails, perf probe can failback to the symbol
based probe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 tools/perf/util/probe-event.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a9cff3a50ddf..af946f68e32e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -779,16 +779,16 @@ post_process_module_probe_trace_events(struct probe_trace_event *tevs,
 
 	map = get_target_map(module, NULL, false);
 	if (!map || debuginfo__get_text_offset(dinfo, &text_offs, true) < 0) {
-		pr_warning("Failed to get ELF symbols for %s\n", module);
-		return -EINVAL;
+		pr_info("NOTE: Failed to get ELF symbols for %s. Use symbol based probe.\n", module);
+		return 0;
 	}
 
 	mod_name = find_module_name(module);
 	for (i = 0; i < ntevs; i++) {
-		ret = post_process_probe_trace_point(&tevs[i].point,
-						map, (unsigned long)text_offs);
-		if (ret < 0)
-			break;
+		if (post_process_probe_trace_point(&tevs[i].point,
+				map, (unsigned long)text_offs) < 0)
+			pr_info("NOTE: %s is not in the symbol map. Use symbol based probe.\n",
+				   tevs[i].point.symbol);
 		tevs[i].point.module =
 			strdup(mod_name ? mod_name : module);
 		if (!tevs[i].point.module) {

