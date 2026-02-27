Return-Path: <live-patching+bounces-2097-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO2LNvjUoWlcwgQAu9opvQ
	(envelope-from <live-patching+bounces-2097-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 18:31:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF931BB7B7
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 18:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B67B730ABF78
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 17:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF5F361658;
	Fri, 27 Feb 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHg0o6Jm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B812B346AC3
	for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772213228; cv=none; b=tGD+7AO+diKop2mrlPy1+yGJ4/2dzFFQ7NInBVGYd8c2cGCnsxBG4fWq4mrRaM4YvHBx2XmNygXmNwqjCNIc+UgTpRe8UUQGnjwha29g1OoORdknhJGAt40/GEMppK/ykcH7yCBvRekcX2IUGyGNC5450lIJI/0EGhA9LqeYOmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772213228; c=relaxed/simple;
	bh=Fg5Jrw4IVvKU3hn7qV5fh+bR7WQGoWAoVrSiTSkdZVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITwksg/naf8x2ZrbccHA2bU6TZUWxp2yzTVUCSDxSat3eKgoOhNCWT23eCDG9mtdmK9PQyiAvnz8fNrz4ZoiooDTnBKaZJ62x8i8Fvn8JV2SM7pE2L2V4ekbwTusrqKtwqSkfHrQguhSrKTJ1FJyboJJrKQ+loyNy2H0dTQ4H78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHg0o6Jm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D46C2BC9E
	for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772213228;
	bh=Fg5Jrw4IVvKU3hn7qV5fh+bR7WQGoWAoVrSiTSkdZVY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GHg0o6JmVh/DHJ+9MH9M0Odk2ZX16T+KhsJeDkhPmq81U8a/Sm5ZMcVrq49JmJ2m1
	 mh+CXLLkrzSHkAfPbfJuMGrQz+/zcLO9pC8ITW99pfCgdYgKr++j/JoYsYKfIEc/m2
	 +9zAZii1lgPbhPZtN0uuK4ukw56Wso6NQbLcVYPuuGEen1/wpeZD6Q6QgkC842+sdV
	 Wmkcmo07osb7IFnOT8PwuZKM+9NVa1PI1Dn2wuDSFA8bH/6Wsh6330kN8CD+0QDe3R
	 oP205YsXz3VkA21wQ47Z9W8baFAncBTHBmKyCEDNI0NsZaNn9FMHyDST1SSyT7Xq40
	 lHEB3vs++bkeA==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-896f9397ecdso28216906d6.3
        for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 09:27:08 -0800 (PST)
X-Gm-Message-State: AOJu0YzlZYTKiW5NJ1U+8PyJ2gy6AIghwB0xMOjqFymuVfTwMXeUajV9
	vAwmyxyWt8EdvDgSD5C/IOtGwMAoMGo/8pK4wmKFyV6YIi2zwVD/CiEK7VMFZMCqYOLGh2AiYj+
	oLsg5TQihSaDvvwZuGG/NoEHawnHoylQ=
X-Received: by 2002:a05:6214:20e3:b0:892:7085:4dd8 with SMTP id
 6a1803df08f44-899d1e88f01mr55996736d6.59.1772213227703; Fri, 27 Feb 2026
 09:27:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
From: Song Liu <song@kernel.org>
Date: Fri, 27 Feb 2026 09:26:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
X-Gm-Features: AaiRm51L5lI08jBwMADuEeu2tBPRPIsMJPTzcnCTLZZ7N6MhUbfPKjhGkH7NHuA
Message-ID: <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
To: Miroslav Benes <mbenes@suse.cz>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2097-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 4BF931BB7B7
X-Rspamd-Action: no action

Hi Miroslav,

On Fri, Feb 27, 2026 at 2:05=E2=80=AFAM Miroslav Benes <mbenes@suse.cz> wro=
te:
>
> Hi,
>
> I have a couple of questions before reviewing the code itself. See below.
> I removed the code completely as it seems better to have it compact. Sorr=
y
> if it is too confusing in the end and I apologize for being late to the
> party. We can always merge the first 7 patches when they are settled and
> keep this one separate.

Yes, I was also thinking this patch will need more discussions than the
rest of the set.

> On Wed, 25 Feb 2026, Song Liu wrote:
>
> > Add selftests for the klp-build toolchain. This includes kernel side te=
st
> > code and .patch files. The tests cover both livepatch to vmlinux and ke=
rnel
> > modules.
> >
> > Check tools/testing/selftests/livepatch/test_patches/README for
> > instructions to run these tests.
> >
> > Signed-off-by: Song Liu <song@kernel.org>
> >
> > ---
> >
> > AI was used to wrote the test code and .patch files in this.
>
> This should go to the changelog directly. See new
> Documentation/process/generated-content.rst.

Thanks for pointing this out. I didn't know we had this guidance.

>
> > ---
> >  kernel/livepatch/Kconfig                      |  20 +++
> >  kernel/livepatch/Makefile                     |   2 +
> >  kernel/livepatch/tests/Makefile               |   6 +
> >  kernel/livepatch/tests/klp_test_module.c      | 111 ++++++++++++++
> >  kernel/livepatch/tests/klp_test_module.h      |   8 +
> >  kernel/livepatch/tests/klp_test_vmlinux.c     | 138 ++++++++++++++++++
> >  kernel/livepatch/tests/klp_test_vmlinux.h     |  16 ++
> >  kernel/livepatch/tests/klp_test_vmlinux_aux.c |  59 ++++++++
> >  .../selftests/livepatch/test_patches/README   |  15 ++
> >  .../test_patches/klp_test_hash_change.patch   |  30 ++++
> >  .../test_patches/klp_test_module.patch        |  18 +++
> >  .../klp_test_nonstatic_to_static.patch        |  40 +++++
> >  .../klp_test_static_to_nonstatic.patch        |  39 +++++
> >  .../test_patches/klp_test_vmlinux.patch       |  18 +++
> >  14 files changed, 520 insertions(+)
> >  create mode 100644 kernel/livepatch/tests/Makefile
> >  create mode 100644 kernel/livepatch/tests/klp_test_module.c
> >  create mode 100644 kernel/livepatch/tests/klp_test_module.h
> >  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.c
> >  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.h
> >  create mode 100644 kernel/livepatch/tests/klp_test_vmlinux_aux.c
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/READ=
ME
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_=
test_hash_change.patch
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_=
test_module.patch
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_=
test_nonstatic_to_static.patch
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_=
test_static_to_nonstatic.patch
> >  create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_=
test_vmlinux.patch
>
> We store test modules in tools/testing/selftests/livepatch/test_modules/
> now. Could you move klp_test_module.c there, please? You might also reuse
> existing ones for the purpose perhaps.

IIUC, tools/testing/selftests/livepatch/test_modules/ is more like an out
of tree module. In the case of testing klp-build, we prefer to have it to
work the same as in-tree modules. This is important because klp-build
is a toolchain, and any changes of in-tree Makefiles may cause issues
with klp-build. Current version can catch these issues easily. If we build
the test module as an OOT module, we may miss some of these issues.
In the longer term, we should consider adding klp-build support to build
livepatch for OOT modules. But for now, good test coverage for in-tree
modules are more important.

>
> What about vmlinux? I understand that it provides a lot more flexibility
> to have separate functions for testing but would it be somehow sufficient
> to use the existing (real) kernel functions? Like cmdline_proc_show() and
> such which we use everywhere else? Or would it be to limited? I am fine i=
f
> you find it necessary in the end. I just think that reusing as much as
> possible is generally a good approach.

I think using existing functions would be too limited, and Joe seems to
agree with this based on his experience. To be able to test corner cases
of the compiler/linker, such as LTO, we need special code patterns.
OTOH, if we want to use an existing kernel function for testing, it needs
to be relatively stable, i.e., not being changed very often. It is not alwa=
ys
easy to find some known to be stable code that follows specific patterns.
If we add dedicated code as test targets, things will be much easier
down the road.

CC Joe to chime in here.

>
> The patch mentiones kpatch in some places. Could you replace it, please?

I was using kpatch for testing. I can replace it with insmod.

> And a little bit of bikeshedding at the end. I think it would be more
> descriptive if the new config options and tests (test modules) have
> klp-build somewhere in the name to keep it clear. What do you think?

Technically, we can also use these tests to test other toolchains, for
example, kpatch-build. I don't know ksplice or kGraft enough to tell
whether they can benefit from these tests or not. OTOH, I am OK
changing the name/description of these config options.

Thanks,
Song

