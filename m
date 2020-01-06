Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A09131B57
	for <lists+live-patching@lfdr.de>; Mon,  6 Jan 2020 23:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFW3O (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Jan 2020 17:29:14 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35165 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFW3O (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Jan 2020 17:29:14 -0500
Received: by mail-pf1-f195.google.com with SMTP id i23so22168082pfo.2;
        Mon, 06 Jan 2020 14:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=diZOMCp7+H8GRYEkNWog4Ps7I49ot4hzmdFa71cNqnE=;
        b=vWofFeX6eERqgExDOv7aZeIVIZPneb5CrDskwtpnOmEaib83SGJppUSicXLLkiR0Sw
         ECP7Zg1Yh9i9rxUtplbHEiDWmhyS30KZtpakfi9SRBHc244NYxeFdkN0il1ZM91B+c39
         iDxqOXHSSZQp10Ds89Rjthh8Ql6hm+yus3sY8uqeOl4VO3c9gw5mbHYzdRvpRm1d16xh
         9X29RgO9DsO7I5RjuaY+Uwg8mPpgcWb++H0AzhFb6lFBtLTgVRE7kyLCaw0ivEJLrE8w
         TgA2dFh9SCNK4ZVmP/kVyoZ8ePNHJReTMqFhlSVBTrtAaWAba9ZRnC3oiheDQe/l7FHa
         fb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=diZOMCp7+H8GRYEkNWog4Ps7I49ot4hzmdFa71cNqnE=;
        b=mjxk8rFmN4nlXCU1DzBjJQBfPdaNxzs7fj5oVMGum2mckb8G3IZii8W3KwHyJ+KDpM
         QKkBF8rIv8XG2GuM0YuSYWxiAkIYC/1AdtynE/Ig5KDC8RuLA+XuNy5sBix9RqdNSt7a
         nWabAYfJRyQ8uSbNd0BbHtdj/wHOghAoQa4/KSoPDrNjXvnuNcz9yZMxNk8Nt6PU5mQj
         hGwspNAu3AqCUp4ROj97qLl+QpKgSCiSSdrq1jmNRq8Mt/jtPuKyyL4IOt3q3Pacsg/X
         sOUxz8aTTFRgwBJXxqukP6jJnK0JhPsaOUQRL1wJaqUbVu5CJ6HoObgKWJD2CFYjHXLR
         l9zw==
X-Gm-Message-State: APjAAAU7Mb2yyPxqjtrFJiWpZ1uSnjpAnCPQKO/Cuf+wUY2hpx1yMqLt
        ukebYyfFEthoSfryT30bsEI=
X-Google-Smtp-Source: APXvYqzbKi4t9HEBGcGGPQoSxQoRLDW/LPWNuNpDDvVYbZHKciQZeFmF6o0uWqHVMF4bt/8tBRJb4Q==
X-Received: by 2002:a63:1c64:: with SMTP id c36mr102033191pgm.302.1578349753644;
        Mon, 06 Jan 2020 14:29:13 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:2bf6])
        by smtp.gmail.com with ESMTPSA id 136sm72399748pgg.74.2020.01.06.14.29.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:29:12 -0800 (PST)
Date:   Mon, 6 Jan 2020 14:29:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        KP Singh <kpsingh@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: BPF tracing trampoline synchronization between update/freeing
 and execution?
Message-ID: <20200106222907.yjoranutzjdersty@ast-mbp>
References: <CAG48ez2gDDRtKaOcGdKLREd7RGtVzCypXiBMHBguOGSpxQFk3w@mail.gmail.com>
 <20200106165654.GP2844@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106165654.GP2844@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180223
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 06, 2020 at 05:56:54PM +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2020 at 05:39:30PM +0100, Jann Horn wrote:
> > Hi!
> > 
> > I was chatting with kpsingh about BPF trampolines, and I noticed that
> > it looks like BPF trampolines (as of current bpf-next/master) seem to
> > be missing synchronization between trampoline code updates and
> > trampoline execution. Or maybe I'm missing something?
> > 
> > If I understand correctly, trampolines are executed directly from the
> > fentry placeholders at the start of arbitrary kernel functions, so
> > they can run without any locks held. So for example, if task A starts
> > executing a trampoline on entry to sys_open(), then gets preempted in
> > the middle of the trampoline, and then task B quickly calls
> > BPF_RAW_TRACEPOINT_OPEN twice, and then task A continues execution,
> > task A will end up executing the middle of newly-written machine code,
> > which can probably end up crashing the kernel somehow?
> > 
> > I think that at least to synchronize trampoline text freeing with
> > concurrent trampoline execution, it is necessary to do something
> > similar to what the livepatching code does with klp_check_stack(), and
> > then either use a callback from the scheduler to periodically re-check
> > tasks that were in the trampoline or let the trampoline tail-call into
> > a cleanup helper that is part of normal kernel text. And you'd
> > probably have to gate BPF trampolines on
> > CONFIG_HAVE_RELIABLE_STACKTRACE.
> 
> ftrace uses synchronize_rcu_tasks() to flip between trampolines iirc.

good catch and good suggestion. synchronize_rcu_tasks() is needed here too.
