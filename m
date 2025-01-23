Return-Path: <live-patching+bounces-1038-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F393AA19CED
	for <lists+live-patching@lfdr.de>; Thu, 23 Jan 2025 03:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3499616BC8F
	for <lists+live-patching@lfdr.de>; Thu, 23 Jan 2025 02:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A3317C91;
	Thu, 23 Jan 2025 02:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gm1oagcD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C01DDD3
	for <live-patching@vger.kernel.org>; Thu, 23 Jan 2025 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598813; cv=none; b=Z1cVVo4rgEg58CGohyWLn1qC0eeQ4GQqPHM2tYRDd8L096RHimdMVD/llWKWd9ZEeqIu/hgHWPOWePqvtHU4LsnseuBh9tie6+M9mZTFJZxN4OPHwFkA6A+NszGUfSpDCJf6BTIOyHHQ78hKbW4cGpCem1YwkAZrS0DNL2A+NDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598813; c=relaxed/simple;
	bh=vQ4S/dBAPpTNz2mVcEf1qDkCSjiQXDucMFWMLhiB8Qc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AMr445c+klwhm9nM1n92r3GEiL9t78xdUBHTFEYqNe8b39yVpcIO01WLNP6vKey+mMtwuvrSro16UAV/r2/c+4eZUJeTDU7t0bPlIEaMPhA96uTljk+mPdEHxE8z4EYzgQZBrifCyhmKKiUIvhCWzzPF98npomSZk8PYOwKyX6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gm1oagcD; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6dd16e1cfa1so4424006d6.1
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 18:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737598810; x=1738203610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoEf/in/s33LYDNVQiOCLtCuJ6rseJiozjjz1vC7e5Y=;
        b=Gm1oagcDbRwZNrK1r5qVgyZrkF5KBKjEeaEJoBYutB1AF3s9Ljc7UbUZmZup8I8GIZ
         lql2EdbXp9aBgia30r2RjcSQY5gU9ZR46kxWOJHWUNHCdQFmBhXtv607mQywXBNqCowH
         vllR24lDMFdmi6H109NExIdZ0CwMI+IbWe/oCzb9Pzw7ZEvoDOWzlZcjjTI1HJLRrWLl
         aHx+TePr7ZRycZ/XuJfiff7b9mqGHUzyCT6fzXJ7yei6VDsicuVpj6SmqYtt4Su4MqPR
         lfUxDGjZd1D2LmU5/GzP032CPTQ0/P3f2rzg/6HucUlQqVpAJFUF2JVYYaX4wNOo/++p
         KUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737598810; x=1738203610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BoEf/in/s33LYDNVQiOCLtCuJ6rseJiozjjz1vC7e5Y=;
        b=kk2sslHj59J4s9/Ih8OHdFz7FlKLSoJu36WrnSRXregszJPTlSX2IaPEYlviGKGNtz
         A5up+jYkqDhoOMw5Qn59wWzCO4W5HjQr4KInBN7GY24Gayz7MzipudFUVrlfTM8tAeJP
         TsuFAINGN5iKBRly7NwIAwsxza02ewj/VolXjFTSZOEL6JSUYuzywnwVDtONp9YmnqhZ
         UJzyL20jv/SP4vqXvsT6U+Q+7Szz+C8g8ZF+6fr7/0Qxr3GuERD9/t3u2IOmrPz/hBIP
         CH9B4nkUiPH2U3dOnFgoJU0B4CLblGQcP/2zPPT79JcVUWZzY24lEiUl6s/78yxpTcPn
         G4IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMhXd0MoqArQcxgab2yIXJNelNALebZ5bzWj1cF2iDQ8QXIUELTFlUQDt0avhxf4yqzS9qsVgadQk7jksJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyux8xP0fF3J+4BUYZ5oJER125BZ6rYPv3sSk6Xle2NFd1lu9EP
	AMwC+XcPfKpc6bqkwUBwaoyTRuK5noo4/f8YjEYVdLbOWGyKEfKvbriKQXZJcbljF7Ubhpe6sPW
	8E8X7tD093WSuVyl9GV3BeRcYejo=
X-Gm-Gg: ASbGncsgZKvCyVIShwgqNAReGkYponF25Wf9VPJG2npeMpQP1QrjKWHJiP5wA7qmC5m
	JlNqVISxOCEFNnBzDijOhTiGlbo1PMw309n8gUtmZ9Thn0fCctAoGt/D5fMLhhpbX
X-Google-Smtp-Source: AGHT+IFzeeFtqQCSlkvn6vWaV7Hl88VIRNO5TJFe0Tr2aGpvph52cx6ahtMfNUHRlPULUc8ec5JiZO1HxQJC9uJyQ14=
X-Received: by 2002:a05:6214:230a:b0:6e1:7b35:a0d5 with SMTP id
 6a1803df08f44-6e1b216fddemr416419636d6.7.1737598810046; Wed, 22 Jan 2025
 18:20:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz> <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
 <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com> <Z5EVL19hj3bnrKjA@pathway.suse.cz>
In-Reply-To: <Z5EVL19hj3bnrKjA@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 23 Jan 2025 10:19:34 +0800
X-Gm-Features: AWEUYZmc46LNpYJICSGgPQ0gtHwvO-iZc3F0xigjbHNUSkZ6-ZINVPJpN7V5ivU
Message-ID: <CALOAHbC5D_uaZScTTa6-ff8pkhq6CQcPFN+rvhBDyx0F9HWY9w@mail.gmail.com>
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching do_exit()
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 11:56=E2=80=AFPM Petr Mladek <pmladek@suse.com> wro=
te:
>
> On Wed 2025-01-22 22:01:31, Yafang Shao wrote:
> > On Wed, Jan 22, 2025 at 9:30=E2=80=AFPM Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > >
> > > On Wed, Jan 22, 2025 at 7:45=E2=80=AFPM Petr Mladek <pmladek@suse.com=
> wrote:
> > > >
> > > > On Wed 2025-01-22 14:36:55, Yafang Shao wrote:
> > > > > On Tue, Jan 21, 2025 at 5:38=E2=80=AFPM Yafang Shao <laoar.shao@g=
mail.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > We encountered a panic while upgrading our livepatch, specifica=
lly
> > > > > > replacing an old livepatch with a new version on our production
> > > > > > servers.
> > > > > >
> > > > My theory is that the transition has finished and some other proces=
s
> > > > started removing the older livepatch module. I guess that the memor=
y
> > > > with the livepatch_61_release6 code has been freed on another CPU.
> > > >
> > > > It would cause a crash of a process still running the freed do_exit=
()
> > > > function. The process would not block the transition after it was
> > > > removed from the task list in the middle of do_exit().
> > > >
> > > > Maybe, you could confirm this in the existing crash dump.
> > >
> > > That's correct, I can confirm this. Below are the details:
> > >
> > > crash> bt
> > > PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
> > >  #0 [ffffba6f273db9a8] machine_kexec at ffffffff990632ad
> > >  #1 [ffffba6f273dba08] __crash_kexec at ffffffff9915c8af
> > >  #2 [ffffba6f273dbad0] crash_kexec at ffffffff9915db0c
> > >  #3 [ffffba6f273dbae0] oops_end at ffffffff99024bc9
> > >  #4 [ffffba6f273dbaf0] _MODULE_START_livepatch_61_release6 at
> > > ffffffffc0ded7fa [livepatch_61_release6]
> > >  #5 [ffffba6f273dbb80] _MODULE_START_livepatch_61_release6 at
> > > ffffffffc0ded7fa [livepatch_61_release6]
> > >  #6 [ffffba6f273dbbf8] _MODULE_START_livepatch_61_release6 at
> > > ffffffffc0ded7fa [livepatch_61_release6]
> > >  #7 [ffffba6f273dbc80] asm_exc_page_fault at ffffffff99c00bb7
> > >     [exception RIP: _MODULE_START_livepatch_61_release6+14330]
> > >     RIP: ffffffffc0ded7fa  RSP: ffffba6f273dbd30  RFLAGS: 00010282
> > >
> > > crash> task_struct.tgid ffff94cd316f0000
> > >   tgid =3D 783848,
> > >
> > > crash> task_struct.tasks -o init_task
> > > struct task_struct {
> > >   [ffffffff9ac1b310] struct list_head tasks;
> > > }
> > >
> > > crash> list task_struct.tasks -H ffffffff9ac1b310 -s task_struct.tgid
> > > | grep 783848
> > >   tgid =3D 783848,
> > >
> > > The thread group leader remains on the task list, but the thread has
> > > already been removed from the thread_head list.
> > >
> > > crash> task 783848
> > > PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
> > > struct task_struct {
> > >   thread_info =3D {
> > >     flags =3D 16388,
> > >
> > > crash> task_struct.signal ffff94cd603eb000
> > >   signal =3D 0xffff94cc89d11b00,
> > >
> > > crash> signal_struct.thread_head -o 0xffff94cc89d11b00
> > > struct signal_struct {
> > >   [ffff94cc89d11b10] struct list_head thread_head;
> > > }
> > >
> > > crash> list task_struct.thread_node -H ffff94cc89d11b10 -s task_struc=
t.pid
> > > ffff94cd603eb000
> > >   pid =3D 783848,
> > > ffff94ccd8343000
> > >   pid =3D 783879,
> > >
> > > crash> signal_struct.nr_threads,thread_head 0xffff94cc89d11b00
> > >   nr_threads =3D 2,
> > >   thread_head =3D {
> > >     next =3D 0xffff94cd603eba70,
> > >     prev =3D 0xffff94ccd8343a70
> > >   },
> > >
> > > crash> ps -g 783848
> > > PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
> > >   PID: 783879  TASK: ffff94ccd8343000  CPU: 81  COMMAND: "java"
> > >   PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
> > >   PID: 784023  TASK: ffff94d644b48000  CPU: 24  COMMAND: "java"
> > >   PID: 784025  TASK: ffff94dd30250000  CPU: 65  COMMAND: "java"
> > >   PID: 785242  TASK: ffff94ccb5963000  CPU: 48  COMMAND: "java"
> > >   PID: 785412  TASK: ffff94cd3eaf8000  CPU: 92  COMMAND: "java"
> > >   PID: 785415  TASK: ffff94cd6606b000  CPU: 23  COMMAND: "java"
> > >   PID: 785957  TASK: ffff94dfea4e3000  CPU: 16  COMMAND: "java"
> > >   PID: 787125  TASK: ffff94e70547b000  CPU: 27  COMMAND: "java"
> > >   PID: 787445  TASK: ffff94e49a2bb000  CPU: 28  COMMAND: "java"
> > >   PID: 787502  TASK: ffff94e41e0f3000  CPU: 36  COMMAND: "java"
> > >
> > > It seems like fixing this will be a challenging task.
>
> Could you please check if another CPU or process is running "rmmod"
> which is removing the replaced livepatch_61_release6, please?

Unfortunately, I couldn't find this task in all the vmcores. It=E2=80=99s
possible that it has already exited.

>
> >
> > Hello Petr,
> >
> > I believe this case highlights the need for a hybrid livepatch
> > mode=E2=80=94where we allow the coexistence of atomic-replace and
> > non-atomic-replace patches. If a livepatch is set to non-replaceable,
> > it should neither be replaced by other livepatches nor replace any
> > other patches itself.
> >
> > We=E2=80=99ve deployed this livepatch, including the change to do_exit(=
), to
> > nearly all of our servers=E2=80=94hundreds of thousands in total. It=E2=
=80=99s a real
> > tragedy that we can't unload it. Moving forward, we=E2=80=99ll have no =
choice
> > but to create non-atomic-replace livepatches to avoid this issue...
>
> If my theory is correct then a workaround would be to keep the
> replaced livepatch module loaded until all pending do_exit() calls
> are finished. So that it stays in the memory as long as the code
> is accessed.

Yes, we=E2=80=99ve been running this test case on a test server, and it=E2=
=80=99s
still working fine so far. We=E2=80=99ll roll it out to more test servers, =
and
hopefully, it=E2=80=99ll serve as a viable workaround.

By the way, isn=E2=80=99t it a common issue in kernel modules that if tasks
are executing code from the module, and you try to rmmod it, the
module should be deferred from unloading until all tasks have finished
executing its code?

>
> It might be enough to update the scripting and call the rmmod after
> some delay.
>
> I doubt that a non-atomic-replace patches would make the life easier.
> They would just create even more complicated scenario. But I might
> be wrong.

The hybrid livepatch mode should serve as a fallback for the
atomic-replace mode. Livepatching has significantly improved our
workflow, but if issues arise within a livepatch, there should be a
fallback mechanism to ensure stability.

>
> Anyway, I am working on a POC which would allow to track
> to-be-released processes. It would finish the transition only
> when all the to-be-released processes already use the new code.
> It won't allow to remove the disabled livepatch prematurely.

Great. Thanks for your help.


--
Regards
Yafang

