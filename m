Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A519A2A2D21
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 15:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgKBOlM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 09:41:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:33474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgKBOlM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 09:41:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604328070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hmEKAQREm+jqesAwSXDRO+rQTKsVN1T127G+Uf+JVEQ=;
        b=MpevfN3GJJcLe+03477VH/DUNhpuduQOcbmSpPfgj+CRO57PsmBxOZi4kSkYQyNn+QwTEh
        XRLu0p4M/LIfHx2kASuQ8NauWXzKqW79XRPyxXpBwTuS/hMTbzcKn+LAFeeMFjqIN0Wzd2
        Vc/jygrb8Kc1YkkysPh2Y9GFWXG9WhQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 55D68AD6B;
        Mon,  2 Nov 2020 14:41:10 +0000 (UTC)
Date:   Mon, 2 Nov 2020 15:41:09 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 07/11 v2] livepatch: Trigger WARNING if livepatch
 function fails due to recursion
Message-ID: <20201102144109.GI20201@alley>
References: <20201030213142.096102821@goodmis.org>
 <20201030214014.167613723@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030214014.167613723@goodmis.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-10-30 17:31:49, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> If for some reason a function is called that triggers the recursion
> detection of live patching, trigger a warning. By not executing the live
> patch code, it is possible that the old unpatched function will be called
> placing the system into an unknown state.
> 
> Link: https://lore.kernel.org/r/20201029145709.GD16774@alley
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Suggested-by: Petr Mladek <pmladek@suse.com>

It has actually been first suggested by Miroslav. He might want
to take the fame and eventual shame ;-)

> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
