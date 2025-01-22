Return-Path: <live-patching+bounces-1037-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F64A195E0
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 16:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AC223A2CCD
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 15:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881E02147E5;
	Wed, 22 Jan 2025 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f32bbqVU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CBB214205
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737561397; cv=none; b=cqohEcQhBRwiKJ7yFxd3rxOpOB8DVu7GN+ylu5DburCvHHRC9ErIPEsVFghX4Lk+s+hPuPNmfwX5TnyoIqlqEFCV+zRGY9NhH5PQBXmzGLK8ESYQKPT6jQcEJG9ANTtPdzumWwMooEZ19DcDD4zPHMc1ujrOPRAOT8xXhHIJNQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737561397; c=relaxed/simple;
	bh=W0xKUpSTR0xKDrXiHnf9AEfcQMWfDSi2ggVT4FAa/2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJMPp12DRevM7F1tDXzrtHRsMMONLAVmEzynCL7LLOrK9g2fAEqQ6dj4OE2Gly0otqOCD673n3W6me5PHoXcRQmTOuYesPp0xsBIT/3n335gHqyK9N+wTcse5z5AYRLhIwOAFx6FSSwDhqCPHDZbtTAG0hFWSBmAiSPkVN5NrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f32bbqVU; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-436249df846so49158535e9.3
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 07:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737561393; x=1738166193; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RnhBnWhfwvynipWEZ+IJ4dZymqlfX7pj/FBwaWFYHXU=;
        b=f32bbqVU2l7oFUbNEcNv3ShpkFi9xMZOw72tR4lRkHJgeDJGhICyK71247SuTH5tAp
         DKThngD0Puj1LOT6479gNYxRvLowF//Z6GPmAtOuosFxassjgi7N7vnxFCUE+69GlA9Z
         3ugWNEYbQ58TtWS3yN4wnPOKt8WOYpq1XQCGBYkP7FdxcxNgaos9wFxsnwZmkdC6Q2Vx
         w2I2E5DopZWCYucO89XvHsz9j1M/Mcf9fUu7+pBbLkPxheHKXSwC2+DhyXVKj5zu8jcr
         l7yo6HssSnBHlk2QAcZPWYgwSZezonAVD2BzmtUO8j4beztZ/1n+eA87j4UFi9+z6NBS
         JnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737561393; x=1738166193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RnhBnWhfwvynipWEZ+IJ4dZymqlfX7pj/FBwaWFYHXU=;
        b=LYKZdWHLwmbr1jWmBASLQTZr84zgQwrDm1CRl+5PYc3wP3opf7rzGKUJeBBOj47FWt
         kuv7+3o5f04qo61Gdfkyi0En+A5kKutsAYadU3q+MLtCVMKrEC4moaD+u+vlPAjdtAxi
         nRcrHwdvMqCHJvsmt3mxS3UXqmFNSzuQt8QqS3Q4NOumbBC2jjI7PVbHIcFm2awTmT+C
         aybx8HrRIP562cwbBhQw6bIMUfS8k2cPudMoaw4l/6uW/K2I1XM1TDl8JlFUK0YZp/cL
         yW0i3q+pRdqt4d3rhYUVGazo3uxkgUwokwiGcKw+j7JMELyJh35nabR1hCsOeOFsibJ+
         ikXw==
X-Forwarded-Encrypted: i=1; AJvYcCUv3grZB+ZlUiz3uvpv2W9tagC0lRlDQk1K0hlul0YwxIWiqZqtED8cPLBbnFS4ks057WG1Vitz79WnB2aV@vger.kernel.org
X-Gm-Message-State: AOJu0YztrVaoB//yusmzran0sr74xCx7vvoI4XZWzrrHz8BcQoAySHVb
	lIj9d+JxOv9WnrUKB4mGX+FvVjos3fo8ul4nrtbEyT5f6XpQCRWQE7jOMgsC/J0=
X-Gm-Gg: ASbGncuO8OILj+861iEBOgDrZ3bnxktwPc23SwxnV/6LMp2c5jFqNLMXToDAphFnPgR
	MDTTGZyMImqPCFSk7dGdXCJiX4izV1E/SGAgQAoA3SBXNyRDKcdeRdRg0m5vO5/ujLPzGxzkDe4
	8GGiJ0+apQANkoraS0d8X1C8+XGgoHvs7UTaqP6ApaMr11OyY0X/uvVYVvPP6t/aX0pQOIMmeNX
	2N8N703BdF9XRCxJgFm7PYDozUxqetyM0L9I+gGaWHxy0EKtBRDjiY3NAupaAe9KzLgOy0=
X-Google-Smtp-Source: AGHT+IF9H2MyQ7ylNJN33PO6yMb3NXVWa9TnWueFHTfLcwS8kFOKOVYs4eKbhtIOi2AejgQSHYOQIw==
X-Received: by 2002:a05:600c:4e0b:b0:434:a525:7257 with SMTP id 5b1f17b1804b1-43891433febmr176113415e9.21.1737561393249;
        Wed, 22 Jan 2025 07:56:33 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b1ce51a6sm25948145e9.1.2025.01.22.07.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:56:32 -0800 (PST)
Date: Wed, 22 Jan 2025 16:56:31 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching
 do_exit()
Message-ID: <Z5EVL19hj3bnrKjA@pathway.suse.cz>
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz>
 <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
 <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>

On Wed 2025-01-22 22:01:31, Yafang Shao wrote:
> On Wed, Jan 22, 2025 at 9:30 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Wed, Jan 22, 2025 at 7:45 PM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > On Wed 2025-01-22 14:36:55, Yafang Shao wrote:
> > > > On Tue, Jan 21, 2025 at 5:38 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > > >
> > > > > Hello,
> > > > >
> > > > > We encountered a panic while upgrading our livepatch, specifically
> > > > > replacing an old livepatch with a new version on our production
> > > > > servers.
> > > > >
> > > My theory is that the transition has finished and some other process
> > > started removing the older livepatch module. I guess that the memory
> > > with the livepatch_61_release6 code has been freed on another CPU.
> > >
> > > It would cause a crash of a process still running the freed do_exit()
> > > function. The process would not block the transition after it was
> > > removed from the task list in the middle of do_exit().
> > >
> > > Maybe, you could confirm this in the existing crash dump.
> >
> > That's correct, I can confirm this. Below are the details:
> >
> > crash> bt
> > PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
> >  #0 [ffffba6f273db9a8] machine_kexec at ffffffff990632ad
> >  #1 [ffffba6f273dba08] __crash_kexec at ffffffff9915c8af
> >  #2 [ffffba6f273dbad0] crash_kexec at ffffffff9915db0c
> >  #3 [ffffba6f273dbae0] oops_end at ffffffff99024bc9
> >  #4 [ffffba6f273dbaf0] _MODULE_START_livepatch_61_release6 at
> > ffffffffc0ded7fa [livepatch_61_release6]
> >  #5 [ffffba6f273dbb80] _MODULE_START_livepatch_61_release6 at
> > ffffffffc0ded7fa [livepatch_61_release6]
> >  #6 [ffffba6f273dbbf8] _MODULE_START_livepatch_61_release6 at
> > ffffffffc0ded7fa [livepatch_61_release6]
> >  #7 [ffffba6f273dbc80] asm_exc_page_fault at ffffffff99c00bb7
> >     [exception RIP: _MODULE_START_livepatch_61_release6+14330]
> >     RIP: ffffffffc0ded7fa  RSP: ffffba6f273dbd30  RFLAGS: 00010282
> >
> > crash> task_struct.tgid ffff94cd316f0000
> >   tgid = 783848,
> >
> > crash> task_struct.tasks -o init_task
> > struct task_struct {
> >   [ffffffff9ac1b310] struct list_head tasks;
> > }
> >
> > crash> list task_struct.tasks -H ffffffff9ac1b310 -s task_struct.tgid
> > | grep 783848
> >   tgid = 783848,
> >
> > The thread group leader remains on the task list, but the thread has
> > already been removed from the thread_head list.
> >
> > crash> task 783848
> > PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
> > struct task_struct {
> >   thread_info = {
> >     flags = 16388,
> >
> > crash> task_struct.signal ffff94cd603eb000
> >   signal = 0xffff94cc89d11b00,
> >
> > crash> signal_struct.thread_head -o 0xffff94cc89d11b00
> > struct signal_struct {
> >   [ffff94cc89d11b10] struct list_head thread_head;
> > }
> >
> > crash> list task_struct.thread_node -H ffff94cc89d11b10 -s task_struct.pid
> > ffff94cd603eb000
> >   pid = 783848,
> > ffff94ccd8343000
> >   pid = 783879,
> >
> > crash> signal_struct.nr_threads,thread_head 0xffff94cc89d11b00
> >   nr_threads = 2,
> >   thread_head = {
> >     next = 0xffff94cd603eba70,
> >     prev = 0xffff94ccd8343a70
> >   },
> >
> > crash> ps -g 783848
> > PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
> >   PID: 783879  TASK: ffff94ccd8343000  CPU: 81  COMMAND: "java"
> >   PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
> >   PID: 784023  TASK: ffff94d644b48000  CPU: 24  COMMAND: "java"
> >   PID: 784025  TASK: ffff94dd30250000  CPU: 65  COMMAND: "java"
> >   PID: 785242  TASK: ffff94ccb5963000  CPU: 48  COMMAND: "java"
> >   PID: 785412  TASK: ffff94cd3eaf8000  CPU: 92  COMMAND: "java"
> >   PID: 785415  TASK: ffff94cd6606b000  CPU: 23  COMMAND: "java"
> >   PID: 785957  TASK: ffff94dfea4e3000  CPU: 16  COMMAND: "java"
> >   PID: 787125  TASK: ffff94e70547b000  CPU: 27  COMMAND: "java"
> >   PID: 787445  TASK: ffff94e49a2bb000  CPU: 28  COMMAND: "java"
> >   PID: 787502  TASK: ffff94e41e0f3000  CPU: 36  COMMAND: "java"
> >
> > It seems like fixing this will be a challenging task.

Could you please check if another CPU or process is running "rmmod"
which is removing the replaced livepatch_61_release6, please?

> 
> Hello Petr,
> 
> I believe this case highlights the need for a hybrid livepatch
> mode—where we allow the coexistence of atomic-replace and
> non-atomic-replace patches. If a livepatch is set to non-replaceable,
> it should neither be replaced by other livepatches nor replace any
> other patches itself.
> 
> We’ve deployed this livepatch, including the change to do_exit(), to
> nearly all of our servers—hundreds of thousands in total. It’s a real
> tragedy that we can't unload it. Moving forward, we’ll have no choice
> but to create non-atomic-replace livepatches to avoid this issue...

If my theory is correct then a workaround would be to keep the
replaced livepatch module loaded until all pending do_exit() calls
are finished. So that it stays in the memory as long as the code
is accessed.

It might be enough to update the scripting and call the rmmod after
some delay.

I doubt that a non-atomic-replace patches would make the life easier.
They would just create even more complicated scenario. But I might
be wrong.

Anyway, I am working on a POC which would allow to track
to-be-released processes. It would finish the transition only
when all the to-be-released processes already use the new code.
It won't allow to remove the disabled livepatch prematurely.

Best Regards,
Petr

