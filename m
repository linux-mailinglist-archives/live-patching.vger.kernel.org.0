Return-Path: <live-patching+bounces-1352-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F4BA7A974
	for <lists+live-patching@lfdr.de>; Thu,  3 Apr 2025 20:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E36151688E4
	for <lists+live-patching@lfdr.de>; Thu,  3 Apr 2025 18:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E164C2517AA;
	Thu,  3 Apr 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgdO38Ci"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57842505AF;
	Thu,  3 Apr 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743705201; cv=none; b=op6EKALpyc4hIwnEuR+SzeUniD7xW4tx8H3Yls639m7LECl1io68cbrIWeHBY8GTWWk9xXZsn/dil0b3c8IG/yO/psxJD6Mof60rhNrlZeqDcNHe+jraigUlxqQSjWObq3TtVhXseVLl7XPs3FhbkE9qBLVNqRnPbTahEguJrBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743705201; c=relaxed/simple;
	bh=cnwALjO3aDbkSmpoYAsVQQnivE8vuaMUt3NU2BV0WpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ImDr15xwbPThDMKV75Bvxe1JwMZPWkh7NTMrkcDaHRjkFaWYcIqkrda/xn47XddosfVuE4di9SvE4iR/gSuG5YBJsAYKu/sJUzTwEu9Jm4YzJ7AcafdoRgupXASEFdBrK6F/8OW+kfSZf4yV0K0S+tn7PZ1NPWcsjoxP6gYuabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgdO38Ci; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E18C4CEE3;
	Thu,  3 Apr 2025 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743705201;
	bh=cnwALjO3aDbkSmpoYAsVQQnivE8vuaMUt3NU2BV0WpE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jgdO38CidHQniGNcR2sC+ZzVsOXUoH2K8myjWri0T5HcvYipuNDs4lgbcjHvjrVbh
	 Sf4iHxjzExRpnkhaiv9r1/BlKPWqicyCYSo/A9e0eiCPOgW8fU713U4suVTJhYK77V
	 dsO3+khmZl8Akd2TefzKtWoAnySfDabJ7ty8IdgFdM1wIFeHYgKFKbGJlAp1cQeBa2
	 sJnCeMlBuPBpHDuR/Z4A6lknbntvHiv1MPdW4Cazd/CGy6TldjLbOHAblnF//lcwX1
	 5JItb5IqAxiBQhkie2JWZvYfIAv+cT1AuLTi1X39M7SXbfUYGksv+Tf7TjSrQt0gq7
	 Mc79aJKNZz1VA==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4766cb762b6so12452441cf.0;
        Thu, 03 Apr 2025 11:33:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6SRX2yYKJSOOVHa6Y1uiiZqMu2tp3FGEKIvoOQDDMubovBYON/Kst2TLLVTrDelFYBaQ=@vger.kernel.org, AJvYcCWBMR7Jl1JiaOorcWow1c4NCBwJArKD/qj7uQ2fiuX4gPlaWh2Godv2nyFpHaytGqpvhCq7pEQP3CKhzM3p@vger.kernel.org, AJvYcCWOmAZ5zP6vt0fbomwcFrdicq9ntwQx3A10tyDumSTZJzv0kTfGaX65FSOsY/ZAlp5fBkRJhA1Y1bpGaDqwBOXnjZm+@vger.kernel.org, AJvYcCXlkXHNL2otTidLfkTC9HyTJPo24C1gZt8OGn44ZlbMvHiYs1EKnxaeJRTJrjliujQNRfJHuAgbM6e5qGhihA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRV/oRxXw5BmvSXeEKqE7OuPDufTEwXPbE1AuEKsJj4di3OfZk
	OBQryehAyR5K2T7WaHl54CN9HUMIE6a4TrGqRiouHr/ngtdDE3d6x3jObXhcx7BeXnPzXlCCsAr
	EQkRvfp2idSgOLlJLJMYmzRafyTU=
X-Google-Smtp-Source: AGHT+IHgqFl4p0VnWKCuwK4rFjCAD/b6TIqBMSxHhJBCN3hmAIwPBR6+/F4WvUV54T0a874dqQqU8P7Nh1AXWgX0j7w=
X-Received: by 2002:a05:622a:143:b0:474:f5fb:b11a with SMTP id
 d75a77b69052e-47924c30da0mr4866911cf.3.1743705200315; Thu, 03 Apr 2025
 11:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
 <20250331100940.3dc5e23a@gandalf.local.home> <Z-vgigjuor5awkh-@krava> <xcym3f3rnakaokcf55266czlm5iuh6gv32yl2hplr2hh4uknz3@jusk2mxbrcvw>
In-Reply-To: <xcym3f3rnakaokcf55266czlm5iuh6gv32yl2hplr2hh4uknz3@jusk2mxbrcvw>
From: Song Liu <song@kernel.org>
Date: Thu, 3 Apr 2025 11:33:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5yBLMPJy3YNoJKUfP+BEsKOgJZ_BjrJnyUQ=tMPqC7ag@mail.gmail.com>
X-Gm-Features: AQ5f1Jq42L8RxZ6GWC42lUCb9tBQ42cKWAQbaPbYFETXEgk6sAOuDqqvH--crIo
Message-ID: <CAPhsuW5yBLMPJy3YNoJKUfP+BEsKOgJZ_BjrJnyUQ=tMPqC7ag@mail.gmail.com>
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch (v6.14)
To: Naveen N Rao <naveen@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Shung-Hsi Yu <shung-hsi.yu@suse.com>, Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, Mark Rutland <mark.rutland@arm.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Vishal Chourasia <vishalc@linux.ibm.com>, 
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Miroslav Benes <mbenes@suse.cz>, 
	=?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 8:30=E2=80=AFAM Naveen N Rao <naveen@kernel.org> wro=
te:
[...]
>
> We haven't addressed this particular interaction in the powerpc support
> for ftrace direct and BPF trampolines. Right now, live patching takes
> priority so we call the livepatch'ed function and skip further ftrace
> direct calls.
>
> I'm curious if this works on arm64 with which we share support for
> DYNAMIC_FTRACE_WITH_CALL_OPS.

We still need to land [1] for arm64 to support livepatch. In a quick test
with [1], livepatch and bpf trampoline works together. I haven't looked
into the arm64 JIT code, so I am not sure whether all the corner cases
are properly handled.

[1] https://lore.kernel.org/live-patching/20250320171559.3423224-1-song@ker=
nel.org/

Thanks,
Song

> > >
> > > Hmm, I'm not sure how well BPF function attachment and live patching
> > > interact. Can you see if on x86 the live patch is actually updated wh=
en a
> > > BPF program is attached?

