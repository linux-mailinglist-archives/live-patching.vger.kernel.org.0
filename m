Return-Path: <live-patching+bounces-1448-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A87ABFB5C
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 18:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A595D4E36B3
	for <lists+live-patching@lfdr.de>; Wed, 21 May 2025 16:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73672222C5;
	Wed, 21 May 2025 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDLKdPbE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA0C18B47C;
	Wed, 21 May 2025 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747845371; cv=none; b=QtarUxUCPZOLnRHGfYtkXPJFjJdYb74NlN2XKMst74xSyfM0D6bkX96JtP5fcOwa4oTVsfycJ3JvNrHJMszt1wQZwqQtsa6Ieu3ahj/kL7oaJtOb6JqFjJ6bg2PdaOfV7BozzJgZ/kQ86g2MIIhzWgcnQcUl5Bl+bc5o5Rs5GGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747845371; c=relaxed/simple;
	bh=stjouTnv41obxBgX2Jr5Nggfpjmbw9/xN8oNI4sNVwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gtzH4YUkZ++DgpKMJUPWNfb7GTbSXwaUpSGGLD6QViC6ySJQAbSYKPBx0CfgFNOAFfxIh0juc9CM4WvN1XEl/jR+QZcKvrHhqcHdj1BtafeZwP/A59VnoxCQSDkOsegoWp80o9KWquUIi8ZeYzTUBpQ7XoNaxcw6edmUHyrh+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDLKdPbE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320C1C4CEEB;
	Wed, 21 May 2025 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747845371;
	bh=stjouTnv41obxBgX2Jr5Nggfpjmbw9/xN8oNI4sNVwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vDLKdPbEIU26V6KMz3z56YmwIdivFxoektboJeuUtpxwxCMa4CctHRYjXkRSVdAPM
	 9Ap6NH7r2VFPRm8S7ZI82Y7b3F/cOA/etal8VMnPn9FToe/mn9jlVKtBXZRNrhnP9g
	 olH9yzEWrPPAxNrvrMJdw+k4bp7oNzDl8KE95d7gH17mJuVvTU/+/oGngErwaYl6rq
	 Tddf29gaoDbwxw/eK/ui0TJLnlmNx5ikWgb8KVVA+ojtYhpIPb2dW/Kavmvtd4HCAU
	 RnO+ilku3BiPS023TjgRjhUumyAImKZRVnwGNGpmH7j1s1CR/g1JlGNbX9bL36j5gL
	 g8i5/MdPnulZQ==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4769bbc21b0so68198671cf.2;
        Wed, 21 May 2025 09:36:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW1s828uA48S+cM4wTuoo1kTztn5dXcSe8RPEnaKGiALLI+YPSMktdmy8VwNy+FTWgsEmH08PghUylfbKMOouKb@vger.kernel.org, AJvYcCWTyUGxMr4ojgAteS1/SWfIcjD13F4vjoNQaoUZ/D6t4AIEjGOL2m0SUqd1QTKZZi3V/JgLyYgqmCW6By2s1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyvr/lO2ge0yQgBp2LDFjQCzOtPNCsy3LyLU3p8mrscnpYpcnv
	nlndYCJqUdCBpjUPri3+1BxIXf9nk3GSEtqu0IMvZfj5SgPJCC1141IxyOwQghbDRhBEHNQgCtN
	GELq23BstUS+xjZvKygHhmEgIG05ML94=
X-Google-Smtp-Source: AGHT+IGyh00A3mWyVANHITaMtbIel7e5S066XRZnxKBJkbXNpdZjwMjgOzjc/fL2tuyzW2TJCVsZfJq+3vsse3D7gYc=
X-Received: by 2002:ac8:5fca:0:b0:494:b1f9:d677 with SMTP id
 d75a77b69052e-494b1f9dbe3mr270777971cf.48.1747845370341; Wed, 21 May 2025
 09:36:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250521111000.2237470-1-mark.rutland@arm.com> <20250521111000.2237470-2-mark.rutland@arm.com>
In-Reply-To: <20250521111000.2237470-2-mark.rutland@arm.com>
From: Song Liu <song@kernel.org>
Date: Wed, 21 May 2025 09:35:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7C0Efu5PB8QKtOLM7yuE=NzNpZbnM_Yn56iTENj9gKHQ@mail.gmail.com>
X-Gm-Features: AX0GCFsUpTu85P307gw4zinTlAbyNsZvOSFEnWi_mt2apNOhLnL8DNMMObdam50
Message-ID: <CAPhsuW7C0Efu5PB8QKtOLM7yuE=NzNpZbnM_Yn56iTENj9gKHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: stacktrace: Check kretprobe_find_ret_addr()
 return value
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, andrea.porta@suse.com, 
	catalin.marinas@arm.com, jpoimboe@kernel.org, leitao@debian.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 4:10=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
> If kretprobe_find_ret_addr() fails to find the original return address,
> it returns 0. Check for this case so that a reliable stacktrace won't
> silently ignore it.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Andrea della Porta <andrea.porta@suse.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Will Deacon <will@kernel.org>

Reviewed-and-tested-by: Song Liu <song@kernel.org>

Tested with livepatch changes [1][2] and modified kpatch
framework.

Thanks,
Song

[1] https://lore.kernel.org/live-patching/20250320171559.3423224-3-song@ker=
nel.org/
[2] https://lore.kernel.org/linux-arm-kernel/20250412010940.1686376-1-dylan=
bhatch@google.com/

