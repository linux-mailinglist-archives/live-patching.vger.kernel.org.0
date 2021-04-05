Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD14354951
	for <lists+live-patching@lfdr.de>; Tue,  6 Apr 2021 01:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhDEXk6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 19:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhDEXk5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 19:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE71261184;
        Mon,  5 Apr 2021 23:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617666050;
        bh=wXcvCpV5lngQfAsxhsTeGFb1bpyuoynRwRXUiAxBCzs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I4gn9Yon5sGPKvk7Mne/CxcIV8unoQeeNrAeKR/0MkHJp0MziBaIuiPtp/5KpJOPM
         9wsbVj3Mgy/11NGt52I8i2WCXgIVzLlZzMBNNquporc3nprlf0X6iJ9ucM9FIp3lyB
         5hIeLWd2qb6sn+mbpK9v/+UyG6tnRZ/aNCt+2E4EUPJDgMQCkhgpXEGLU+3SxYSQKt
         e5QVfGQlLicuQsbH8zAlJB0FCdwmmUAOLaTYSDPY1XIXPBRsbSOcPJ3s4GJ27mpPWS
         s658IHY/HMbzuw77ZTLbazhfer1NiCOosQPYgxlYOviiJnn4bZLW8N2kKPrPV83R9S
         B7uF/rKoc/ocQ==
Date:   Tue, 6 Apr 2021 08:40:46 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, mark.rutland@arm.com,
        broonie@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
Message-Id: <20210406084046.4f0b946728dc01da09045338@kernel.org>
In-Reply-To: <7dda9af3-1ecf-5e6f-1e46-8870a2a5e550@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
        <20210330190955.13707-1-madvenka@linux.microsoft.com>
        <20210403170159.gegqjrsrg7jshlne@treble>
        <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
        <20210405222436.4fda9a930676d95e862744af@kernel.org>
        <7dda9af3-1ecf-5e6f-1e46-8870a2a5e550@linux.microsoft.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 5 Apr 2021 09:56:48 -0500
"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:

> 
> 
> On 4/5/21 8:24 AM, Masami Hiramatsu wrote:
> > Hi Madhaven,
> > 
> > On Sat, 3 Apr 2021 22:29:12 -0500
> > "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:
> > 
> > 
> >>>> Check for kretprobe
> >>>> ===================
> >>>>
> >>>> For functions with a kretprobe set up, probe code executes on entry
> >>>> to the function and replaces the return address in the stack frame with a
> >>>> kretprobe trampoline. Whenever the function returns, control is
> >>>> transferred to the trampoline. The trampoline eventually returns to the
> >>>> original return address.
> >>>>
> >>>> A stack trace taken while executing in the function (or in functions that
> >>>> get called from the function) will not show the original return address.
> >>>> Similarly, a stack trace taken while executing in the trampoline itself
> >>>> (and functions that get called from the trampoline) will not show the
> >>>> original return address. This means that the caller of the probed function
> >>>> will not show. This makes the stack trace unreliable.
> >>>>
> >>>> Add the kretprobe trampoline to special_functions[].
> >>>>
> >>>> FYI, each task contains a task->kretprobe_instances list that can
> >>>> theoretically be consulted to find the orginal return address. But I am
> >>>> not entirely sure how to safely traverse that list for stack traces
> >>>> not on the current process. So, I have taken the easy way out.
> >>>
> >>> For kretprobes, unwinding from the trampoline or kretprobe handler
> >>> shouldn't be a reliability concern for live patching, for similar
> >>> reasons as above.
> >>>
> >>
> >> Please see previous answer.
> >>
> >>> Otherwise, when unwinding from a blocked task which has
> >>> 'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
> >>> original return address.  Masami has been working on an interface to
> >>> make that possible for x86.  I assume something similar could be done
> >>> for arm64.
> >>>
> >>
> >> OK. Until that is available, this case needs to be addressed.
> > 
> > Actually, I've done that on arm64 :) See below patch.
> > (and I also have a similar code for arm32, what I'm considering is how
> > to unify x86/arm/arm64 kretprobe_find_ret_addr(), since those are very
> > similar.)
> > 
> > This is applicable on my x86 series v5
> > 
> > https://lore.kernel.org/bpf/161676170650.330141.6214727134265514123.stgit@devnote2/
> > 
> > Thank you,
> > 
> > 
> 
> I took a brief look at your changes. Looks reasonable.
> 
> However, for now, I am going to include the kretprobe_trampoline in the special_functions[]
> array until your changes are merged. At that point, it is just a matter of deleting
> kretprobe_trampoline from the special_functions[] array. That is all.
> 
> I hope that is fine with everyone.

Agreed, that is reasonable unless my series is merged. 

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
