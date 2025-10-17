Return-Path: <live-patching+bounces-1762-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D05B0BEBC8C
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 23:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59F94188CF4E
	for <lists+live-patching@lfdr.de>; Fri, 17 Oct 2025 21:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BD0289358;
	Fri, 17 Oct 2025 21:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDhvQ2KP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152923A98E
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760735476; cv=none; b=PhBzOxCYjnMxP4+Jk79/iULGVJo/bwKx/CkuqcSt6Wd2Ach96nxfhHknXZRjfVebGVuUEGD/v5LHT5GUjKUB/4A7PrDaxPO48Gagq70Y/oklpj/9Eh7nXTJ0hxO9R2I9002LsThxL6M042iqGagGOQPmblbKWI+RKJu9AQqydvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760735476; c=relaxed/simple;
	bh=YahkfQeKvW8ZAEm7N0zNICAqx12A1bfGd3ug9WXmAuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QpboaraskuGNgL5ze9Xdbz9D4qR9LIt28/453oKvIE/RywwQG4YCNdjUgdLM6FzmqDEaUVmimdQKVVdduqRGxbryPmMRJp9d0rSqieB1RKd+DnqyIhgF6EKFEsZLB0U2JZshAqb0HCrkyqW1/h/117Mtjz7KG5V+S4e8xYYtRN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDhvQ2KP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772A7C116C6
	for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 21:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760735475;
	bh=YahkfQeKvW8ZAEm7N0zNICAqx12A1bfGd3ug9WXmAuM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TDhvQ2KPnnasW8F8DANdEqHGNKv4Y+MaBENWCdrWqCgtknHDmQeqn+YyqJH2AOFNZ
	 EOcTaS0y1zC2PflzXoNzyE8S+CDc0bs4wsSz7exfek1G9HA58rAJMJwSJ5oGvfECm8
	 RdPRxJr3Xg2QPvCvTE4dJCqzJ4dTkVLjdW9IrUwwX/dVbgRh6Ye2L+SkR8vlAA2ZEH
	 8dJtUgV2iQeU+ESzjlmQknJ7hcmm3L5AuAjAco41n1eE+mvb4FK6+3LbDqLTtvApT1
	 j3YHUATPqe6Z8CHv3xY/nlKFtyH0CamJwV3AJs01hDYGMr+9l6TbcurXb15y2Z9khC
	 jBEXk3jOZppuA==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87bb66dd224so31570496d6.3
        for <live-patching@vger.kernel.org>; Fri, 17 Oct 2025 14:11:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWrj604hWRjixDR6JxMUs8LdA5gSTK4XdlaVMLNsw4ht/DP0yIFzGzH9PBXraUTURqo4LmbcMZ44UArEI9v@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh3rpqo3FJV4mK3aR565Nk85BZCggsP2QV4hd8JOoGwmNoY6zW
	+ZE0yZZS/nvcqHEpATm9kf5AHri3zz9EuzWYotkUwBc8h9J+gwkZ9Sukq9h09GovmHY4/bYrd7e
	9mdMEWqgFMvNuk/h4rISSFHZ74/JV0oA=
X-Google-Smtp-Source: AGHT+IEfSRvbZrL0mQFArIH+DvCAbvpWx/NpHje5yZDGeDLdOfWmVQTqqdw8UYY2gYcc+OkCewLXE/V/ioIhezx66yg=
X-Received: by 2002:a05:622a:14cb:b0:4e7:1fe9:c071 with SMTP id
 d75a77b69052e-4e89d28087cmr68880271cf.29.1760735474587; Fri, 17 Oct 2025
 14:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com> <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
In-Reply-To: <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Fri, 17 Oct 2025 14:11:03 -0700
X-Gmail-Original-Message-ID: <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
X-Gm-Features: AS18NWCfvA7ttKQjozknLu86ETkSOEkrv06ZjwoRu3viQU2Wk6X0UOhiBOOUcR4
Message-ID: <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 12:48=E2=80=AFPM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
>
> On 10/17/25 15:07, Song Liu wrote:
> > On Fri, Oct 17, 2025 at 9:58=E2=80=AFAM Song Liu <song@kernel.org> wrot=
e:
> >> On Thu, Oct 16, 2025 at 2:55=E2=80=AFPM Andrey Grodzovsky
> >> <andrey.grodzovsky@crowdstrike.com> wrote:
> >> [...]
> >>> [AG] - Trying first to point him at the original  function - but he
> >>> fails on the fexit I assume  - which is strange, I assumed fexit
> >>> (kretfunc) and livepatch can coexist ?
> >>>
> >>> ubuntu@ip-10-10-114-204:~$ sudo bpftrace -e
> >>> 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EX=
EC
> >>> START (fentry): PID %d, Comm %s\n", pid, comm); }
> >>> fexit:vmlinux:begin_new_exec { $latency =3D nsecs - @start[tid];
> >>> delete(@start[tid]); printf("<- EXEC END (fexit): PID %d, Comm %s,
> >>> Retval %d, Latency %d us\n", pid, comm, retval, $latency / 1000); }'
> >>> Attaching 2 probes...
> >>> ERROR: Error attaching probe: kretfunc:vmlinux:begin_new_exec
> >>>
> >>> [AG] - Trying to skip the fexit and only do fentry - he still rejects
> >>> ubuntu@ip-10-10-114-204:~$ sudo bpftrace -vvv -e
> >>> 'fentry:vmlinux:begin_new_exec { @start[tid] =3D nsecs; printf("-> EX=
EC
> >>> START (fentry): PID %d, Comm %s\n", pid, comm); }'
> >>> sudo: unable to resolve host ip-10-10-114-204: Temporary failure in n=
ame
> >>> resolution
> >>> INFO: node count: 12
> >>> Attaching 1 probe...
> >>>
> >>> Program ID: 295
> >>>
> >>> The verifier log:
> >>> processed 50 insns (limit 1000000) max_states_per_insn 0 total_states=
 3
> >>> peak_states 3 mark_read 1
> >>>
> >>> Attaching kfunc:vmlinux:begin_new_exec
> >>> ERROR: Error attaching probe: kfunc:vmlinux:begin_new_exec
> >> OK, I could reproduce this issue and found the issue. In my test,
> >> fexit+livepatch works on some older kernel, but fails on some newer
> >> kernel. I haven't bisected to the commit that broke it.
> >>
> >> Something like the following make it work:
> >>
> >> diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
> >> index 2e113f8b13a2..4277b4f33eb8 100644
> >> --- i/kernel/trace/ftrace.c
> >> +++ w/kernel/trace/ftrace.c
> >> @@ -5985,6 +5985,8 @@ int register_ftrace_direct(struct ftrace_ops
> >> *ops, unsigned long addr)
> >>          ops->direct_call =3D addr;
> >>
> >>          err =3D register_ftrace_function_nolock(ops);
> >> +       if (err)
> >> +               remove_direct_functions_hash(direct_functions, addr);
> >>
> >>    out_unlock:
> >>          mutex_unlock(&direct_mutex);
> >>
> >> Andrey, could you also test this change?
> > Attached is a better version of the fix.
> >
> > Thanks,
> > Song
>
> Thank you Song!
>
> So, with this You say both fentry and fexit will work no issues ?

Yes, fentry and fexit should both work.

> So juts to understand, as i am not familiar with live-patch generation,
> I get the sources for my Ubuntu kernel, I apply your patch, I also
> generate manually livepatch module that makes a dummy patching to my
> test function (begin_new_exec), and apply this patch to my running
> costum kernel ? Because i don't think the stadard ubuntu livepatching
> will agree to apply his livepatch CVEs to my ostum kenel, it will
> probably recognize it's not stock ubuntu kernel but amanully built one.

livepatch is a kernel module. Therefore, unless the two kernels are almost
identical, livepatch built for one kernel cannot be used on the other.

If you build the kernel from source code, there are some samples in
samples/livepatch that you can use for testing. PS: You need to enable

  CONFIG_SAMPLE_LIVEPATCH=3Dm

I hope this helps.

Thanks,
Song

