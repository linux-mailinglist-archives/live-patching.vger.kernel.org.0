Return-Path: <live-patching+bounces-1526-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DF6AEA22D
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 17:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A8661C61D66
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 15:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E12F2353;
	Thu, 26 Jun 2025 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyhnMc5x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A52EBDFF;
	Thu, 26 Jun 2025 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750949741; cv=none; b=IIb2KBCL6zI5zbmYUHJL/S1EDKYHL1FZepZSRl1Wg6TA+e7PqY1aSmj1iZ9dYwVrcBzGdLbduhQLtsfU5V9sp+zRtxviZ6VLwz+5yLLvEnlUVphjvU2MuhkOoq6t4oGfI7xv5a4+HbpsCcdOyovn9wBf7RmEbej+XECHiXme34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750949741; c=relaxed/simple;
	bh=DGtkFajgBy5udwP1+SQyc/+NPUr1gDTyvaO2eS3ihj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OJokOensjO00tk5f9xQmRt52CByVDCiw2IIdOYIymDwNw9Y4IktAQu/h9mEC+BdZp4a4yae+P6tR2qrbt0x/yq4EbJ98T5r5X9OgAMh8E+AvbS/qsgMRYKlCkBKUjSTZtC9/WM164Mj8jryQsdqstcz9cAGwRnL5bTNBO/opEkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyhnMc5x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A35C4CEF0;
	Thu, 26 Jun 2025 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750949740;
	bh=DGtkFajgBy5udwP1+SQyc/+NPUr1gDTyvaO2eS3ihj0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jyhnMc5xGPJLn4P++dosbLXQZL4QxAEJQFmfUbIMqSzy0FvPUi+6N1DOVcEIMaq3D
	 JdEUiNQVPspb1ONVd8CT9FvuvS+6i2kqVrHonm3vHTNu44T/brpEgZ4q4putsdyxtf
	 42hNI77Zq39eLT3+PSOoln71KoyXT3a4iarDzBslzjKEJtNYjluXDPMHeZ0R+SVh95
	 RpF5I+ECH+LxJiC00K+VEgKF9MwcNyhUL7rtVlQwmNPETqlnXWjf1jPxjnLZ+SeTWn
	 1qmMl+H3jdMepSJTDjnubu/chnM4ivRXz3GNandS1osIQQz/Z8+d8oX5qawzfLK7pH
	 A67HxDSr/jr3g==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7d09f11657cso107240285a.0;
        Thu, 26 Jun 2025 07:55:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXbwy6Co6QC3eIydHPQsivdLbkMT1Vm7d8SBWtEWvUVEeHUQAj2jOe5Zy0C7BfHl/mhwJMrrfxOE/bMutU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSiba37fQ0TW/JHlrp5R1fu0fwWUGTp5Xolt+XEiRxED2gbfuj
	+Y9g6Df0tgygNrRWZ7+avaaQ8wtHS4EGBrZqPVgc2QdYuMgdl8F27kknL++YlU7f0s6072VdOuD
	/SkNN5lVq2vjXcRmT2HQJ9SJX+Db80bE=
X-Google-Smtp-Source: AGHT+IG453uIeIzNK1RT8uSCLSfYk4hwSyRjXLdI0t8DLEoiD5sm9itRUfxIKnFH0+C76uoY1IsM9oGAI70wauAlivY=
X-Received: by 2002:a05:620a:1657:b0:7d3:e97a:bb10 with SMTP id
 af79cd13be357-7d43ba6ef0amr449772085a.3.1750949739641; Thu, 26 Jun 2025
 07:55:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617173734.651611-1-song@kernel.org> <aF1JShCkslGkch26@willie-the-truck>
In-Reply-To: <aF1JShCkslGkch26@willie-the-truck>
From: Song Liu <song@kernel.org>
Date: Thu, 26 Jun 2025 07:55:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7WY54jYDBtApRRw4mnjM0cZu4GBUZQ58ZHAV+zd79uXw@mail.gmail.com>
X-Gm-Features: Ac12FXx0pE4VqQoOzbDrAh5sYwqSYnsX3wO2PeWjT7CUcSzqsHYdzfhwvDBdOyE
Message-ID: <CAPhsuW7WY54jYDBtApRRw4mnjM0cZu4GBUZQ58ZHAV+zd79uXw@mail.gmail.com>
Subject: Re: [PATCH v4] arm64: Implement HAVE_LIVEPATCH
To: Will Deacon <will@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	catalin.marinas@arm.com, dylanbhatch@google.com, fj6611ie@aa.jp.fujitsu.com, 
	mark.rutland@arm.com, kernel-team@meta.com, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Torsten Duwe <duwe@suse.de>, Breno Leitao <leitao@debian.org>, 
	Andrea della Porta <andrea.porta@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

Thanks for your kind review!

On Thu, Jun 26, 2025 at 6:21=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Tue, Jun 17, 2025 at 10:37:34AM -0700, Song Liu wrote:
> > This is largely based on [1] by Suraj Jitindar Singh.
>
> I think it would be useful to preserve at least some parts of the
> original commit message here so that folks don't have to pull it out
> of the list archives if they want to see more about the rationale.

The relevant message from the original commit message is:

Allocate a task flag used to represent the patch pending state for the
task.

Shall I respin this patch to add this? Or maybe Catalin can add
this while applying the patch?

Thanks,
Song

