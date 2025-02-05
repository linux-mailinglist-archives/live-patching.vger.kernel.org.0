Return-Path: <live-patching+bounces-1116-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF76EA291A3
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 15:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A9E23ABC26
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 14:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91494193079;
	Wed,  5 Feb 2025 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNWiolF+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE64616F8E9;
	Wed,  5 Feb 2025 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766581; cv=none; b=hijIQLtGmEHWBXkHywd5vpIpEryh5arElaZzFm0ms6f1Y5nQB1o6SumhQqAeC/slHZiEq3ZUi4Ay8Cp5sx1PZe5EkUfqN4a/BHOXhLixJuJZllm+PKQbUMXJQjSy3AIGCvdNax/Ntp71vB9gof+Iws38UeFY7NnU34L8WL3G1DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766581; c=relaxed/simple;
	bh=pxPrpQtSkz7WTkkbhF56Ah+Jjv3OOSaUrIduQSvxATw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EX8WIhjdhj8rDmWRete2gxNjmd3hRC3IMNtxbqoqnk9QuE4HIsKFnM+7R4WrId7R+PR9BuAqKX83MkBlH1xImo2bslEfO8iMHj7zEiy538LSUdXzrxlCF3m3uh4moB2qh44yz46TlhBQH0iE6X3LxXFmSIjMRspV87VNED060Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNWiolF+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6dd43b08674so55215936d6.3;
        Wed, 05 Feb 2025 06:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738766578; x=1739371378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFzsOPSraP8pWQ6hdTBusCwaArPsMDcf5Y8fnfjtPn8=;
        b=RNWiolF+OObsY8+IkafvJ9TVoU71O6waqY17zMmaukZFyRRXdGYR9m7TGGnuNfG+PX
         EiN2Tima1bOKOM48/UAy9hi6yIeUV+Q01sXygTG2WG4+P4dsgYxaGh0/gR56JhTLkDuD
         2eb0TxhmsgKbZhRWYOHr7vZFtIUsCHgLhraJrYdEYHkOcIB2DVwPuyYU8v2szPej9S9C
         5ZbFkGo7Zj4Eln8Wt/R6hkXHjQQrXJ0aPifiFr/oCuT85vmbix9KtIWDoBsIYUkdLruG
         NiNcN5tTver7jOXOJ1f8vx2tk7wuyW37/I8NIUkrAkShI/JIp4Q5UaUc9UG95O4EGmbI
         PaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738766578; x=1739371378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFzsOPSraP8pWQ6hdTBusCwaArPsMDcf5Y8fnfjtPn8=;
        b=rKMe7yjVhMTWL7goZ9irb7ySYAkOKPGEgQXwxFm238F8yCvi1vX8+LnobzCaEAKJhi
         k6yUT48DaC4YbGdy8iaNXMTrY74t7W5nQWnREXl4Ejfger+v2wVTwHebOX4Ochhzkg55
         6WVVRET1EA2ZhBMCGi/fTVgVOaaLT7t38AHzZaZKAT1Xrc524aLSUpzMSH95E/l0n++K
         cph64qIHChD0dQxs2yQ8o8/FTEMZx+Bl/eeL3FJXXXsgWlAYp66qvIJgTEryCYBapIDR
         0ZnX1jtwFpY9CroSiumT94wuL1VTtV0YMB1NH9G8TugXtGk7faR677wxO4CERMufPwxd
         T23g==
X-Forwarded-Encrypted: i=1; AJvYcCVTIBbhnhUDdEMdtrg/IsEvX2UZlMVBtGkd6yHQFPEPXli3t56UrbSC7vh6moOBEfpTYbI=@vger.kernel.org, AJvYcCVv0aI7XssPEYvzWnOKzEwsFTQeBK9Ttx/AMQkLJjAU69tsZYLbm4ofEPbp/mtaZSGBsv2nWyEZPcixODGpzA==@vger.kernel.org, AJvYcCWXTqtBWuhoBn0XjlltZ2Ot+RKwYjamCwy1U4QT95jpgt+KWOT+eFa+QZsor0G5Igw12h1s+IwB/2NoGoi4@vger.kernel.org
X-Gm-Message-State: AOJu0YyFL/CL/7vPdbcHeOVBf/gBan+pAEOYRctpv5PZ2myhCyMmNH1V
	tXv+hOnNnFnG+YeEu51lflaONJcyQZ8a9J5/TNi1VrRwzqQ2Jkc94w8T7vhvQTCvKUbKKWYBuOw
	QKSX29hG1gWDzK3KohUwighRzur0=
X-Gm-Gg: ASbGnct46InTbcjfzRxHL/ho/9iqzvbkDjDblKLBSXabbGrUxUHNVoDKqE9cc/v2Tz3
	Y1VtH5/jX3Ln3NoJsEQjYPDWg25+Vctd+rvqV2OccF3iU0kj2GsYOHdOYMpNkiz4hOENXfniB+Z
	E=
X-Google-Smtp-Source: AGHT+IFKfZToqyEyoAVsrV43a7M2CwkfiKaSMz8lXrHMo8mub3uCrMmx0G7Lp4NNbnh3sttIBBFRb8dK0jdXnsLDgro=
X-Received: by 2002:a05:6214:f65:b0:6d8:a39e:32a4 with SMTP id
 6a1803df08f44-6e42fbd7774mr64739136d6.25.1738766578494; Wed, 05 Feb 2025
 06:42:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 5 Feb 2025 22:42:22 +0800
X-Gm-Features: AWEUYZlYBaJ7_HWYEwzsSoc5umVv1UdxRh8C-Yzyz673yROmd2m8vXQhiJA83zA
Message-ID: <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, 
	jikos@kernel.org, joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 5:53=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Mon, Feb 3, 2025 at 1:45=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> [...]
> >
> > If you=E2=80=99re managing a large fleet of servers, this issue is far =
from negligible.
> >
> > >
> > > > Can you provide examples of companies that use atomic replacement a=
t
> > > > scale in their production environments?
> > >
> > > At least SUSE uses it as a solution for its customers. No many proble=
ms
> > > have been reported since we started ~10 years ago.
>
> We (Meta) always use atomic replacement for our live patches.
>
> >
> > Perhaps we=E2=80=99re running different workloads.
> > Going back to the original purpose of livepatching: is it designed to a=
ddress
> > security vulnerabilities, or to deploy new features?
> > If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot of ro=
om for improvement.
>
> We only use KLP to fix bugs and security vulnerabilities. We do not use
> live patches to deploy new features.

+BPF

Hello Song,

Since bpf_fexit also uses trampolines, I was curious about what would
happen if I attached do_exit() to fexit. Unfortunately, it triggers a
bug in BPF as well. The BPF program is as follows:

SEC("fexit/do_exit")
int fexit_do_exit
{
    return 0;
}

After the fexit program exits, the trampoline is still left over:

$ bpftool  link show  <<<< nothing output
$ grep "bpf_trampoline_[0-9]" /proc/kallsyms
ffffffffc04cb000 t bpf_trampoline_6442526459    [bpf]

We could either add functions annotated as "__noreturn" to the deny
list for fexit as follows, or we could explore a more generic
solution, such as embedding the "noreturn" information into the BTF
and extracting it when attaching fexit.

Any thoughts?

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d77abb87ffb1..37192888473c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22742,6 +22742,13 @@ BTF_ID(func, __rcu_read_unlock)
 #endif
 BTF_SET_END(btf_id_deny)

+BTF_SET_START(fexit_deny)
+BTF_ID_UNUSED
+/* do_exit never returns */
+/* TODO: Add other functions annotated with __noreturn or figure out
a generic solution */
+BTF_ID(func, do_exit)
+BTF_SET_END(fexit_deny)
+
 static bool can_be_sleepable(struct bpf_prog *prog)
 {
        if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
@@ -22830,6 +22837,9 @@ static int check_attach_btf_id(struct
bpf_verifier_env *env)
        } else if (prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
                   btf_id_set_contains(&btf_id_deny, btf_id)) {
                return -EINVAL;
+       } else if (prog->expected_attach_type =3D=3D BPF_TRACE_FEXIT &&
+                  btf_id_set_contains(&fexit_deny, btf_id)) {
+               return -EINVAL;
        }

        key =3D bpf_trampoline_compute_key(tgt_prog,
prog->aux->attach_btf, btf_id);


--
Regards
Yafang

