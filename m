Return-Path: <live-patching+bounces-1759-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBADBEAEE5
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 18:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A42A1AE2B33
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 16:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C22E2F0699;
	Fri, 17 Oct 2025 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4EJmMUw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E792EE616
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720313; cv=none; b=UySo/EqV81bpsjDMYSEKUg4GzhE7050Q21kvo2E6jEe8bC1tm1V8rIlI+2YNv36A75ydIVyKsyXOd39YxDXbLPOxdfqTjxDgX/p8Kf4+kyuTheL1JiS1f/GDCkZAUTU3lNhziR0IakHhz99JQgRePMq4+hKCVa/ETAojQY3KrA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720313; c=relaxed/simple;
	bh=1vX3koOovWpolcvQOiaq12AdUoeLlFOkctmccaUXyPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqDwo9v/mZJ5feuYXpWYb9pcAKcB0kkow4FKjbvAfaBk3vdzasWaOU+Z19BwGvwMZZfGTWDrbK5u566V+UBe8BB2C217042sdfD7ENaXb++sTdiIuRl2XTj3Uaz3maiVwC801wsf/9udJPC3BDaGtKojK7Y4xLyUIELWJp5MTuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4EJmMUw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73F5C4AF09
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760720312;
	bh=1vX3koOovWpolcvQOiaq12AdUoeLlFOkctmccaUXyPs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f4EJmMUwO9RE1asUyXjlWAcAhwLQ9y9lcrPU1fUuuJLcZgn0DfsuWmDIEkyQwYQlp
	 t3UNbPDI87L467qg6fQcnPJg0qPfQe6ZM00Y1nx0jtLCNifAm3VA1rx6C+adp+zW9i
	 1hRbVK8HOm+hAAvmdsp0EqvtKEg1lWqITbQuDwvScP+V4e+FOSTZSMnQ3ytSi0TyVr
	 uZVb9TtLnY+eItRS3gLGNnre0wbSDjz7lyXA77wLFZkj7dyixHv7HCKvWKC4h/TqNz
	 +Z477MUsSirtaQSQQpnUP/654dTBTcttpwSkm7HLxqRMUFDTKjs2Lub+cgMBQ1fi5Y
	 Q/xrgEnULrmfQ==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8608f72582eso158346685a.2
        for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 09:58:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVsdCYtE39A4D41aE1xNvSwNfLyIEPJr+3tSXMorJ0T5RguIfhmCotIYKphRXnJA4Q55JO3eByaGgGjSmmE@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/MkhclDe602+t+Tj1fXQ7nEIkp/+ktIQ3Zhu8bTAQZNVQyjbW
	8g7Irchf7PkarJjtmqIt1TuE+OYufrym+qjJFoQCpQovHPhHz/1QlVc1isDr+WN3Vy5ef433NSn
	+2e+HYo3gDLLjpo6FSrazFi8uHXKAStk=
X-Google-Smtp-Source: AGHT+IE0WgonDFM1jHOebXDxqFdOw0DLdIYcY8BBckAF5YsVqntMCMEB4MuurxtdH/0pu7mdaBtj9/hgXdrXX+xogJY=
X-Received: by 2002:a05:622a:698c:b0:4e8:a45b:f723 with SMTP id
 d75a77b69052e-4e8a45bfddemr21235511cf.83.1760720311820; Fri, 17 Oct 2025
 09:58:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com>
In-Reply-To: <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Fri, 17 Oct 2025 09:58:18 -0700
X-Gmail-Original-Message-ID: <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
X-Gm-Features: AS18NWBkEMG-5AnyUzRhnDH-v5itl1_Z5BWSdoAz-hAhdYksQufU_iI0cJjYDio
Message-ID: <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 2:55=E2=80=AFPM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
[...]
> [AG] - Trying first to point him at the original  function - but he
> fails on the fexit I assume  - which is strange, I assumed fexit
> (kretfunc) and livepatch can coexist ?
>
> ubuntu@ip-10-10-114-204:~$ sudo bpftrace -e
> 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EXEC
> START (fentry): PID %d, Comm %s\n", pid, comm); }
> fexit:vmlinux:begin_new_exec { $latency =3D nsecs - @start[tid];
> delete(@start[tid]); printf("<- EXEC END (fexit): PID %d, Comm %s,
> Retval %d, Latency %d us\n", pid, comm, retval, $latency / 1000); }'
> Attaching 2 probes...
> ERROR: Error attaching probe: kretfunc:vmlinux:begin_new_exec
>
> [AG] - Trying to skip the fexit and only do fentry - he still rejects
> ubuntu@ip-10-10-114-204:~$ sudo bpftrace -vvv -e
> 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EXEC
> START (fentry): PID %d, Comm %s\n", pid, comm); }'
> sudo: unable to resolve host ip-10-10-114-204: Temporary failure in name
> resolution
> INFO: node count: 12
> Attaching 1 probe...
>
> Program ID: 295
>
> The verifier log:
> processed 50 insns (limit 1000000) max_states_per_insn 0 total_states 3
> peak_states 3 mark_read 1
>
> Attaching kfunc:vmlinux:begin_new_exec
> ERROR: Error attaching probe: kfunc:vmlinux:begin_new_exec

OK, I could reproduce this issue and found the issue. In my test,
fexit+livepatch works on some older kernel, but fails on some newer
kernel. I haven't bisected to the commit that broke it.

Something like the following make it work:

diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
index 2e113f8b13a2..4277b4f33eb8 100644
--- i/kernel/trace/ftrace.c
+++ w/kernel/trace/ftrace.c
@@ -5985,6 +5985,8 @@ int register_ftrace_direct(struct ftrace_ops
*ops, unsigned long addr)
        ops->direct_call =3D addr;

        err =3D register_ftrace_function_nolock(ops);
+       if (err)
+               remove_direct_functions_hash(direct_functions, addr);

  out_unlock:
        mutex_unlock(&direct_mutex);

Andrey, could you also test this change?

Thanks,
Song

