Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB12A96BE
	for <lists+live-patching@lfdr.de>; Fri,  6 Nov 2020 14:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgKFNNV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Nov 2020 08:13:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgKFNNV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Nov 2020 08:13:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604668398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/qFlNeW+fj9kPag6iPvAKbxfuQxHVIdXyO+NAnfQv1k=;
        b=M+tR/rKxslTPuT6FfxTzbpuuxYbiZZG3CnqFYk93k8am/VLmSymRvyUiwOy4Hr5waPoLce
        uQiZvPathsmCgazo7IfORam7PuE22q5xJHq/iNivwhCmxch4+MaufWlLk/oXEAcDNCMlcc
        x3wJTN1WOECehMoqwdLrqgU3bZ/wBxo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6BB69AB8F;
        Fri,  6 Nov 2020 13:13:18 +0000 (UTC)
Date:   Fri, 6 Nov 2020 14:13:17 +0100
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
        Jonathan Corbet <corbet@lwn.net>, Guo Ren <guoren@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-doc@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 11/11 v3] ftrace: Add recording of functions that caused
 recursion
Message-ID: <20201106131317.GW20201@alley>
References: <20201106023235.367190737@goodmis.org>
 <20201106023548.102375687@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106023548.102375687@goodmis.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2020-11-05 21:32:46, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> This adds CONFIG_FTRACE_RECORD_RECURSION that will record to a file
> "recursed_functions" all the functions that caused recursion while a
> callback to the function tracer was running.
> 
> Changes since v2:
> 
>  - Use trace_recursion flags in current for protecting recursion of recursion recording
>  - Make the recursion logic a little cleaner
>  - Export GPL the recursion recording

JFYI, the code reading and writing the cache looks good to me.

It is still possible that some entries might stay unused (filled
with zeroes) but it should be hard to hit in practice. It
is good enough from my POV.

I do not give Reviewed-by tag just because I somehow do not have power
to review the entire patch carefully enough at the moment.

Best Regards,
Petr
