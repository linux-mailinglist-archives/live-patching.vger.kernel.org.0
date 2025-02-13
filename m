Return-Path: <live-patching+bounces-1185-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C36C1A34FED
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 21:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38F1316EFBC
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 20:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93097266B6E;
	Thu, 13 Feb 2025 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pc+cVpYp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6599A266180;
	Thu, 13 Feb 2025 20:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739479580; cv=none; b=sOT5SJUxyLH9xcuz+gTdaWbU0eIu5/RCcHsRC16BAg2DqM9js+T/oVRpnsb7aKNGhkXEGqx2mt1KE5INGIYCimGPWztifNPHrTQL2c4+/bsr5MPBARmtyQ0VO49bF7jaA9xl9d9Dz0RuGG1az50Nrah1Y6Q3pXI1eHq+WuKUXss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739479580; c=relaxed/simple;
	bh=1Hv1W5PIRbegvr3gIqvOw2rrDiC6G9t1Dr/tCrD03e4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UvI4WUPxBVnfcYLVEr9sVoHAfTzg/stJojri+xercZjVvn6MDLXN8Sm0SJeFdBGjSsM66zFQRjUe9aZeW9h/tJ1wzgDE3TpSiW5o+46C9OTGqfG1xM9sAjoXqUZXlzwwdLXqu6o63UYhxzTfUfWXfcuJOZES9vH++hBM5I8NIJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pc+cVpYp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADCCC4CEE9;
	Thu, 13 Feb 2025 20:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739479579;
	bh=1Hv1W5PIRbegvr3gIqvOw2rrDiC6G9t1Dr/tCrD03e4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pc+cVpYpVZcf6SPMc0R4TZfa9dQgW/98u31mFBPL6EqlUEgpeqxiquPXLdZZPUMHr
	 XKlJVilhTTClQTbKNTB0MAKFBw86OLoP4k30EQ0+OHdMP0uszjwwhnmCkH2FaiGAaS
	 eCRjHlGOvhxl3xY/o1DmVFpRMvF8zYtzYzM8+LSRKzD6q569tkZUbmnVre5GQqJhjg
	 BoM+rpVOjjRGo/vbisYr2rlyw8glE6AZ7dXlw/bFDU/b4fs7CLTQegiMGHMG1svc94
	 8uCQTaioL8TWofbISnJ0wtN3WwqCegD3iJe8wcxYr/JTdi29y9Pw8yqRaqXJ7FLJTd
	 94RUXcfCZPpsw==
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3cfc79a8a95so3431405ab.2;
        Thu, 13 Feb 2025 12:46:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWBzvWWJQbD0ZaNDqbaaG+uFKEI7kRYg05FHMKDhPKfBmLh6cN6CdxTpi9KsJ/pEPfQFnZXbyZ5e89VA+c=@vger.kernel.org, AJvYcCWjN/2FIkaEaCdf3Yz2rtVvZvdDoYjL8Ts2yRTJHGf7jXVFJm0wQkDUZ6OgIg9rTF/UYQpn8QoFY9aBxy453w==@vger.kernel.org, AJvYcCXlkp/Z1xatYO2jLNpciORGYWQRkz07kQDq5lJ8j73S4kOFqFmUTa+y5tuZFf7DGg8vZtwThn/4CyilrfcQeZ++VQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVk2R6RKg8QrLDD3wvX/zvzJnnKbx4CG/XbsyMZoSzd86x3pW4
	wFgIHIIv6NBQfA1AINgBx0dwKvKo1U/dncOr3L2pjcQrH6G3wmzTQEC9of8BuR48hPxO+WRqNZk
	guzCkYy91qXOZeTmDiS3Nl8KU0LA=
X-Google-Smtp-Source: AGHT+IGQ7pJ/TiGbTLryDYR2+5szRZiiwjnj755YU/aasn/qcPVr55ah50aMoRFrQI9umJnTpry+8wekUMj6OpAzbMc=
X-Received: by 2002:a05:6e02:20cc:b0:3cf:f844:68eb with SMTP id
 e9e14a558f8ab-3d17bdff4afmr78463815ab.4.1739479579147; Thu, 13 Feb 2025
 12:46:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com> <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org> <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org>
In-Reply-To: <mb61pseoiz1cq.fsf@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 13 Feb 2025 12:46:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
X-Gm-Features: AWEUYZkl0WveZP-8jA0rX6lZvo2HZZiSPy4b5e09ftMa4XtdnE-_yHKMbg6ADZc
Message-ID: <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 12:38=E2=80=AFAM Puranjay Mohan <puranjay@kernel.or=
g> wrote:
[...]
>
> P.S. - The livepatch doesn't have copy_process() but only copy_signal(),
> yours had copy_process() somehow.

In my build, copy_signal is inlined to copy_process, unless I add noinline.
If I do add noinline, the issue will not reproduce.

I tried more combinations. The issue doesn't reproduce if I either
1) add noinline to copy_signal, so we are not patching the whole
   copy_process function;
or
2) Switch compiler from gcc 14.2.1 to gcc 11.5.0.

So it appears something in gcc 14.2.1 is causing live patch to fail
for copy_process().

Thanks,
Song

[...]

