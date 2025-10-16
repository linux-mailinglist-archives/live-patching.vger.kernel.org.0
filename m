Return-Path: <live-patching+bounces-1757-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D07EEBE5934
	for <lists+live-patching@lfdr.de>; Thu, 16 Oct 2025 23:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C15024F9271
	for <lists+live-patching@lfdr.de>; Thu, 16 Oct 2025 21:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A98623185D;
	Thu, 16 Oct 2025 21:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Af9cAcjS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6286E253B5C
	for <live-patching@vger.kernel.org>; Thu, 16 Oct 2025 21:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760650348; cv=none; b=mFb8FZd+xiMJGqgm1NZAdawIg9cgXEiBt4CGHL7MI3UKM1iLhiC792dZojcOvZh5aOy79tsZdCW8Zjt4gN4+l9fOE2fzK2jyB21o2Zao2iqE2Pi27NmS/eHsyByBo9Fdx53MsB5VNZ7ZHG28EtOJB+TlPObFryHGz0gRsNAnJ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760650348; c=relaxed/simple;
	bh=Pi26o0V0v3zPH7ydMsgH6xH+0lVqy7jx7jq8lcNOh54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXFhu+w7JLHPUi9oSMJBHDwNhQE1rI/VOweEXCCg8jPq6doU7IVsAQmHU662Yibhck0z9pZlq5ExoOQC6wxDaHGI1gN11HqjljnEPO02lrptW3GVQySA2IfPrN7ifPru2b62dicWD3ejr0FXMBGIdRL/Pm62eTWgnafCv/BUWVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Af9cAcjS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3331C4AF0B
	for <live-patching@vger.kernel.org>; Thu, 16 Oct 2025 21:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760650347;
	bh=Pi26o0V0v3zPH7ydMsgH6xH+0lVqy7jx7jq8lcNOh54=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Af9cAcjSNGQwl3SW2Cg0QYu7eQ2mQw4gyUphF4wdmrgAmud+5HD6n1EG9uW9I1ga/
	 YgdPSJDQqiHlN5Eamv6r06t6qte+5lRJ85CUPj5fVbW6pgWXL4L5m0+QHTVk22ItN4
	 i8f6IBKhqxJDMvGvImY5H56HDa5suUj9de+2l8thuUqky9NjLloyG6JgTokHo2t067
	 vKvKRJZtmlKY5WbMeNUDhD1TtUVJc5L6TEUXSPlwSTGk0466omAwyT1FjrlSb03d2g
	 JJrAV5D4DLusnNuR0oMyJwkRTPvtGFt2xJB1bXJ8Sc2ra+BSnIfJc//QJNzj/Alg+W
	 wPhlKsS9PUJ9g==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-87c1cc5a75bso11563576d6.3
        for <live-patching@vger.kernel.org>; Thu, 16 Oct 2025 14:32:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW14cEDf+p4YXmA3PiDKpubZUwYw7/s1/Qzro5/N6+gO0NES7uz8rnnpKMWoJxJrRHOYjvHOhWrTtuQxbGO@vger.kernel.org
X-Gm-Message-State: AOJu0Ywum6mvM8hQHYiHrSyUxqvc/vko+zo90Y1Ghh7xF3UyjyJiWRSf
	9h/sw2KciakSwnqvO5oyueMlMMJtiylwpSOCu1gLUmd+4ViuoQ1s+6lLWi0e+8GElt67UcX5jKI
	aj5bL8ZKogweN3qF3x1z+xapDZmRIhu4=
X-Google-Smtp-Source: AGHT+IF15Wj+H9mAcXmeZ1byg2qUG4YpBUn7IwTl+XZ4TzprnhC4V1NNYUn4u3YWIFsTOWGuQ8SVljSn7wBjIka2eNU=
X-Received: by 2002:a05:6214:2485:b0:7fd:2bc6:6cad with SMTP id
 6a1803df08f44-87c20542e53mr27977706d6.10.1760650346997; Thu, 16 Oct 2025
 14:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz> <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz>
In-Reply-To: <aPDPYIA4_mpo-OZS@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Thu, 16 Oct 2025 14:32:13 -0700
X-Gmail-Original-Message-ID: <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
X-Gm-Features: AS18NWAVOfAcdc9Qgnm_z-Ic_luQv5aT_WOhbPuRL2-Jno8Q17PE-gHQ1_5tC08
Message-ID: <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Petr Mladek <pmladek@suse.com>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Song Liu <song@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 3:56=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> Added Song Liu and Steven into Cc because they are more familiar with
> the ftrace trampolines.
>
> On Wed 2025-10-15 17:11:31, Andrey Grodzovsky wrote:
> > On 10/15/25 07:53, Petr Mladek wrote:
> > > On Tue 2025-10-14 21:37:49, Andrey Grodzovsky wrote:
> > > > Dear Upstream Livepatch  team and Ubuntu Kernel team - I included y=
ou both in this since the issue lies on the boundary between Ubuntu kernel =
and upstream.
> > > >
> > > > According to official kernel documentation  - https://urldefense.co=
m/v3/__https://docs.kernel.org/livepatch/livepatch.html*livepatch__;Iw!!Bmd=
zS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO_MoRRlkKsymUTDP4PGvvP=
aV0TDVYhziOYMm9WnUGu5TeFxUxQ$ , section 7, Limitations -
> > > > 1 - Kretprobes using the ftrace framework conflict with the patched=
 functions.
> > > > 2 - Kprobes in the original function are ignored when the code is r=
edirected to the new implementation.
> > > >
> > > > Yet, when testing on my Ubuntu 5.15.0-1005.7-aws (based on 5.15.30 =
stable kernel) machine, I have no problem applying Livepatch and then setti=
ng krpobes and kretprobes on a patched function using bpftrace (or directly=
 by coding a BPF program with kprobe/kretprobe attachment)and can confirm b=
oth execute without issues. Also the opposite works fine, running my krpobe=
 and kretprobe hooks doesn't prevent from livepatch to be applied successfu=
lly.
> > > >
> > > > fentry/fexit probes do fail in in both directions - but this is exp=
ected according to my understanding as coexistence of livepatching and ftra=
ce based BPF hooks are mutually exclusive until 6.0 based kernels
> > > >
> > > > libbpf: prog 'begin_new_exec_fentry': failed to attach: Device or r=
esource busy
> > > > libbpf: prog 'begin_new_exec_fentry': failed to auto-attach: -16
> > > >
> > > >
> > > > Please help me understand this contradiction about kprobes - is thi=
s because the KPROBES are FTRACE based  or any other reason ?
> > > Heh, it seems that we have discussed this 10 years ago and I already
> > > forgot most details.
> > >
> > > Yes, the conflict is detected when KPROBES are using FTRACE
> > > infrastructure. But it happens only when the KPROBE needs to redirect
> > > the function call, namely when it needs to modify IP address which wi=
ll be used
> > > when all attached ftrace callbacks are proceed.
> > >
> > > It is related to the FTRACE_OPS_FL_IPMODIFY flag.
> >
> >
> > I see, that explains my case as my probes are simple, print only probes=
 that
> > defently don't that the ip pointer.
> >
> > But i still don't understand limitation 2 above doesn't show itself - h=
ow my
> > kprobes and especially kretprobes, continue execute even after livepatc=
h
> > applied to the function  i am attached to ? The code execution is redir=
ected
> > to a different function then to which i attached my probes...
>
> The code is rather complicated and it is not obvious to me.
>
> But I expect that kretprobes modify return addresses which are
> stored on the stack. They replace them
> with a helper function (trampoline) which would process
> the kretprobe callback and jump to the original return address.
>
> It works even with livepatching. The only requirement is that
> the function returns using a "ret" instruction which reads
> the return address from the stack.
>
> > Also - can you please confirm that as far as i checked, starting with k=
ernel
> > 6.0 fentry/fexit on x86 should not have any conflicts with livepatch pe=
r
> > merge of this RFC -
> > https://lkml.iu.edu/hypermail/linux/kernel/2207.2/00858.html ?
>
> My understanding is that the above mentioned patchset allowed to use
> livepatching and BPF on the same function at the same time. BPF used
> to redirect the function to a BPF trampoline. And the patchset allowed
> to call the BPF trampoline/callback directly from the ftrace callback.

Yes, the patch set above allows BPF trampoline to work on the same
function at the same time with livepatch. After this patchset, BPF
trampoline no longer sets FTRACE_OPS_FL_IPMODIFY.

Thanks,
Song



> Best Regards,
> Petr
>
> > >
> > > More details can be found in the discussion at
> > > https://urldefense.com/v3/__https://lore.kernel.org/all/2014112110251=
6.11844.27829.stgit@localhost.localdomain/T/*re746846b6b16c49a55c89b4c63b79=
95fe5972111__;Iw!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO=
_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu6pjuIgig$
> > >
> > > I seems that I made some analyze when it worked and it did not work,
> > > see https://urldefense.com/v3/__https://lore.kernel.org/all/201411211=
02516.11844.27829.stgit@localhost.localdomain/T/*mffd8c8bf4325b473d89876f28=
05f42f1af7c82d7__;Iw!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJ=
VXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu5xbeoulA$
> > > But I am not 100% sure that it was correct. Also it was before the
> > > BPF-boom.
> > >
> > > Also you might look at the selftest in the todays Linus' tree:
> > >
> > >    + tools/testing/selftests/livepatch/https://urldefense.com/v3/__ht=
tp://test-kprobe.sh__;!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbj=
DJVXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu5RXF-AnA$
> > >    + tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
> > >    + tools/testing/selftests/livepatch/test_modules/test_klp_livepatc=
h.c
> > >
> > > The parallel load fails when the Kprobe is using a post_handler.
> > >
> > > Sigh, we should fix the livepatch documentation. The kretprobes
> > > obviously work. register_kretprobe() even explicitely sets:
> > >
> > >     rp->kp.post_handler =3D NULL;
> > >
> > > It seems that .post_handler is called after all ftrace handlers.
> > > And it sets IP after the NOPs, see kprobe_ftrace_handler().
> > > I am not sure about the use case.
> > >
> > > Best Regards,
> > > Petr
> >
> >

