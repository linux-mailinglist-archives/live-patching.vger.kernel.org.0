Return-Path: <live-patching+bounces-1775-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CD4BF3421
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 21:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D7F3F4FCC68
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 19:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573832BEC23;
	Mon, 20 Oct 2025 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jq4jJFXA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318491EDA0B
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760989462; cv=none; b=Gn5QfE8JBEg7SMzDiAkgDgt4I/hAPPko47cEF+mfCIxfiFQrD30OgKB0SFpgfezhL2jgYa/k7qBoJDxO+urwmqVKzk5W6UCiwyAzUkW/r67upi4MI5Yn/g6Sg2780hqON4fgW+kXaU/iRPzzxRl2Pu46E+okgYFDnBvngamP8Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760989462; c=relaxed/simple;
	bh=MFBweVZk1wRQZbDb66uFf6sdBNPjk/5yO05+ZuNxNFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZDaPcTS4vg/nOXEsmfXTv78RMTaF2bzbM9nhro2A0QbR3fFiChOYOz0D7KJUMcxUMWEC8C2MY/dehVrlj5FX5O9jXhX/Ldp5cyOyL0lPJ3LY3u55nnP0Vamj5WYfsPgC1i8/2Cxegj2+i1dYNn2BM5EGSD60CA/ix9l1sj9lUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jq4jJFXA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A41C116D0
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760989461;
	bh=MFBweVZk1wRQZbDb66uFf6sdBNPjk/5yO05+ZuNxNFk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jq4jJFXAlZO1G/SMS/7eSYswSMlb0du6Are1nn0CXssp5Q425DxB3N5RKig9ONysl
	 fFK2pJCQVmht49+K6NoCPsioHYATwdJ3q3IDKLrtBcM/VHjOFgjFH2RM3hSy2MqDER
	 tozowML4dXrzDmXFY/Pi7fmDEM6gDZIcrpKgkDgvWhOHkwkuWmXTQ/yA6BUeGHD6yf
	 p0n0pVYDrhaeYETzRPtvwtvAWLd6DYrXEauScQ7uY1ocqGKzA6lTsQNDZkoyonrCfk
	 +rCAEhPw71oE5n7vbRFBxQ8Bvm2MoyyPUNfKSzVbXi0B6kekoz/b6KY2TJV8NievF7
	 a189iHu+83B9g==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87dcb1dd50cso59264496d6.3
        for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 12:44:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXtRonjbM+a6PWRJi+llRulpwcpyFno/vrjpslFGki/qLYMxVo9bjpxA9xLCHyXEI22ATCZylKFm7cFcJ2k@vger.kernel.org
X-Gm-Message-State: AOJu0YwJc5ANBLKfSP9CBSurj8Z6smuwtd9SpadijZ0cktb48bxXWiNV
	om89k+5it0m4zgj/bHw4eK9l2iPY612ZhWnQ6gk6e23KRrfYsx+DB+zET5gYuIG6oPkEg5a+HXy
	DWGlYaEU1Nr9prtreGZOg3/v/dh2iRRw=
X-Google-Smtp-Source: AGHT+IEET/6PkeSCE2CChNOunpcRnhHxsFq3urMHLMlQl4LfaYnbWznexEdi2nPn8OUDKAFFAS7AdVXmrsSQHdv9UoI=
X-Received: by 2002:a05:6214:4012:b0:87c:22eb:36b9 with SMTP id
 6a1803df08f44-87c22eb377fmr177276156d6.9.1760989460836; Mon, 20 Oct 2025
 12:44:20 -0700 (PDT)
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
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com> <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com> <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com> <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
 <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
In-Reply-To: <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Mon, 20 Oct 2025 12:44:09 -0700
X-Gmail-Original-Message-ID: <CAHzjS_sZBwuJtNjbO84kJ8EFnTeP35+=SPCO8SLYVi1rGa2N9w@mail.gmail.com>
X-Gm-Features: AS18NWBnVklVhfkZPiyJr58msCKaZQxVX_NgTba15Vfp0igR9AkWH5_S6evuNxY
Message-ID: <CAHzjS_sZBwuJtNjbO84kJ8EFnTeP35+=SPCO8SLYVi1rGa2N9w@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 12:10=E2=80=AFPM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
[...]
> Seems reasonable to me, we are simply cleaning the entry on failure so
> we don't encounter it late anymore.
> So I will apply this patch ONLY and retest - correct ?

Right, we only need this small change.

> Another question - it seems you found where it broke ? I saw 'Cc:
> stable@vger.kernel.org # v6.6+' in your prev. patch.'
> If so , can you please point me to the offending patch so I add this to
> my records of my discovery work of bpf coexistence
> livepatching ?

The commit that causing the issue was in the Fixes tag:

Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash
while in use")

Thanks,
Song

