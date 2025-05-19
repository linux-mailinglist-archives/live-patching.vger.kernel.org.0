Return-Path: <live-patching+bounces-1442-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D622ABC54C
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 19:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 809503AA5C8
	for <lists+live-patching@lfdr.de>; Mon, 19 May 2025 17:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72AA6288C22;
	Mon, 19 May 2025 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vA2bxeQ2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609720AF87
	for <live-patching@vger.kernel.org>; Mon, 19 May 2025 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747674679; cv=none; b=Mg0dDWrHUN190s/SrL1bTSLHnEKPU3hr0Iwn6emauGb+TAwrnW/NAJHyi/x4Myky3QlBtv7ZLhtYnh7kwqeppsSfLCyfzx6jacNGMYwynQAkbEDQezWFW/03RZtE7jurHDV3rUeMPuEtUFKmRE8YHixs+GV7L6NRSSlkIxjfzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747674679; c=relaxed/simple;
	bh=J9+AOPXxrsjtGniILsGnZjKCgDv3F7K2+yKjpaFrVAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5dDu0Yf1UEhhvQJpshzZufR4nvlKq+vS68x7bSJONkMypUiBN8ZcKcNmXHvcWdbvlFanYGgR6fKcSeikkFW0qPGu4Ei2NG3YrVquPVWajMIgNvkNAnatX5eHVg/viq1/tEYRslNwppAAj3bOdixzeJTUetEYX0oW4e7v9Pt3Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vA2bxeQ2; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3f6dccdcadaso3734874b6e.2
        for <live-patching@vger.kernel.org>; Mon, 19 May 2025 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747674676; x=1748279476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9+AOPXxrsjtGniILsGnZjKCgDv3F7K2+yKjpaFrVAI=;
        b=vA2bxeQ2hxhxrjv579QWNYg9GDXb8fdMYCFA9URc94af113SsbNyv+30o7+SURKiIg
         6zFMajDF17S87QgUndDl5EPnFqFtLptDbgBybksXAt8OkZOS4yxJyGIOMu3/5q56UYQM
         Y0Ed5JQwjbAs3zdh5wwgLSttv+fvHO6whtpDTQVlnGTJHd+lBhlQBXlGdoZDvAn3HkSi
         W0i5Nn9d7Y3mgWCvKFQJ+gNiKCx4dXq024tG+1A+8E4hcCJc8rFOD/sPYYB+ptxCYJgs
         iY3hvRPnn4SVvm1i2y8XpP4GFWdebGDBRv1T1PKYdvdBd7s80J99akTaMByPt5s/79W+
         qAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747674676; x=1748279476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9+AOPXxrsjtGniILsGnZjKCgDv3F7K2+yKjpaFrVAI=;
        b=su4ZEGEOFQfKnPDVf0yAVv542tuYtVCWWoppnAJTFf8UWAOj0MeLiAaHJiMycrSdhr
         unUSAhc5xXodsDVLi5JhMRxU8NTMuwOFpyqM4A7Ha45hjSw7qRsDZhr/f+OJiOH1NLJg
         FIs/3+XzBQuNPUv4LDMpIPeKtzaUZIL/52pHh+fz3gfQJfTa3HQJRNKYcCuXOaLNnIXx
         kzkXS2QdRQ3JEbQGe1KlvdmlRtb0x6Yc/jycOxifnKBjF+U4aBtFK8CkpBvuOwKCcneW
         OquyeI8iO8pvKJIqW0y9gOV2qz1nJbQ6W3Ul9WrjVhgluD5e/ct3oMrXlvGQAvEPLr/4
         lSqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdm2NBpmMMHmmkbYOWcVYdnggC3au2pLAuH2HnIaea5+Hh3cnkGyXr4YkCYUTH/JQc01gMYCBk998zS2yl@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Gs/A35EB8x+YMj35ck1F0MZosZVldDTB1xPMr6UG2nhC7Vt6
	Q0DtI2MhwkQ0iLR064zXQLBMAJtCFcCKVm/jC1+YwA1wgxySzMxRRS4zEDu4ki4O44p416G0TzB
	b/qfzYtfgKov4WeUPcAD9WT0H3ec9DbEIts8FI1vX
X-Gm-Gg: ASbGncvWzRi3sIEa1mSCtkhJvbCT/E+0Wqf7SXs94vixsqqLOoFRjVAaEhLFaBe8O55
	OZbqT9l5gAhLAVW0QCTKMxV6/zcXRyKojXjhV6kXEX3epfqX07iNKLihspQ65+tvrNLb+ihm+Qv
	vRb7A2djUig4FmXuu+wHwbsr7PCntCj9bwgtDG3I1YkUQ=
X-Google-Smtp-Source: AGHT+IGbc3Cqvl0hgY9PsJO87Lm1XcEa46xCiiwbO5jWDmdGQWmCs6c23IP7AUXSBHo3+nusSu+IzZxGz9BjH90D83k=
X-Received: by 2002:a05:6808:6c91:b0:404:df89:85d9 with SMTP id
 5614622812f47-404df8988e9mr6567361b6e.33.1747674675605; Mon, 19 May 2025
 10:11:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250320171559.3423224-1-song@kernel.org> <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
 <CAPhsuW4MAcVpXmZVQauoaYe0o3tDvvZfgmCrYFFyFojYpNiWWg@mail.gmail.com> <aCtfAcg32kbczs-g@J2N7QTR9R3>
In-Reply-To: <aCtfAcg32kbczs-g@J2N7QTR9R3>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 19 May 2025 10:11:04 -0700
X-Gm-Features: AX0GCFsWLG4-Bb9vmj3DbSo8XE63IQ1V3WuVgVTvtIAVe62z6XsrFewtIVMSBqU
Message-ID: <CADBMgpzPyW+EnB3A1Hr=LQGhuen4pUuJ0QYa44nH0qfQ9TFaSQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
To: Mark Rutland <mark.rutland@arm.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> FWIW: I reviewed the patch above ([1]) already but didn't hear anything
> back.

Sorry for the delay on this, last week was busier than expected on my
end. I'm aiming to send the revised patch within the next couple of
days.

On Mon, May 19, 2025 at 9:40=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
> I've had a quick look at [1], and IIUC that's a hard prerequisite for
> livepatching, as without it the kernel *will* crash if it attempts a
> late module relocation.
>

This is correct. In both module-patch scenarios (module is loaded
first, or patch is loaded first) the relocations on the livepatch
module occur after it is already RX-only, so a crash is inevitable
with the current relocation code.

Thanks,
Dylan

