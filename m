Return-Path: <live-patching+bounces-2681-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oACCCriD9Gn8BwIAu9opvQ
	(envelope-from <live-patching+bounces-2681-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:43:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B79D24ABB78
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B4C4B30055A7
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E55388364;
	Fri,  1 May 2026 10:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRbNQ2K7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C91A3164
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777632181; cv=none; b=m2MrEnedvgMgPSegqRUdLdB6bHAQ7s2Rhy6oXCIljqYknyX4dU9mVibrR38k6eEb0h6em0wVqwpPMR0iB6z5zk3wqeVRnYIuNgcvA+QwB5+H5EScj1gSETSt8YPkbzGn4fWX3nLYr/jTooFJ3I6cVlNtbqsKaVYC90p5XBGmsfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777632181; c=relaxed/simple;
	bh=kJ4IASbft8gJJxdjWdPuwFjSskKz4N4kha/aEwpZDF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hUkf1yRt28OvJGSUxp0s6/nEosBzY8eIZtUux+CGcRFsA6rLFMjqpBV7CvXrvMw12cADHWrU02Mu7nPNtq2PHooOJonFwH+2DMDrLpozJjGNPAlX/jNWDBfdSLH99Us7+Vh/mq63vEIKhvaFfAuikl5RZxAz4x6oCyLvZ2xQvWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRbNQ2K7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2943AC2BCC7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632181;
	bh=kJ4IASbft8gJJxdjWdPuwFjSskKz4N4kha/aEwpZDF0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hRbNQ2K7Y0ClA3wuXZWBe4Tfstq5Dbf11pyHOwtabM4tmxxVCS41eE2s1kZ8oHPSd
	 CB/m3+PKd/9DtdWeiUNi+Hvq1bQ+Qnv1CPBpcxgNJ80kJJorl+DerN/qnBPCNWcv+P
	 amaikdvPEayV13uyP7GaEQ8hBnnaSmACQh5NM/k1USogsV9dJuGWPPWtQnee+h+v0U
	 WsTh916Agd40NMNGlu90IIn+VJjvG+lTLm+nELMAfi1Ptv9gSp5500DTk0ux9OilFy
	 d60hpd3Q3OBVzYYE/pJvQSxXkL5NvZBReuPOI0AyL95KKXX5gTdmxBwotcL32/zcph
	 iI1K6myuNQx1Q==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso18938026d6.3
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:43:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/gbE8s3s9o5ZPDGjxsLASdh3LPNXAmGnlcPlxpLLtuWFCEzB/QAwXc1xo14m5YzpoTG9eudy0TF61jWB/P@vger.kernel.org
X-Gm-Message-State: AOJu0YzScRDD/PjuWB8kvW5Mq12yJwP+IjcIqt/2Bx1FHNGnaubraIAK
	MtWv/2t4Lj4SOqTl2W9BhjxKSOEBRa5DR17tLblKnQPbEj8qOkHRT/fxGBiNciQiF6SDMPTCUOk
	5MtOK1ZT9KzRioFRuKXonqgvtFswGsKA=
X-Received: by 2002:ad4:4ead:0:b0:8ac:b24a:f543 with SMTP id
 6a1803df08f44-8b54838c847mr35364316d6.50.1777632180360; Fri, 01 May 2026
 03:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <63b0d7848597ad6011e1f56c8fdd53593d09a992.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <63b0d7848597ad6011e1f56c8fdd53593d09a992.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:42:46 +0100
X-Gmail-Original-Message-ID: <CAPhsuW6tG20xWmjK9PxeW53ybMF5EL+zu=URpQ=VM4fyBqROWw@mail.gmail.com>
X-Gm-Features: AVHnY4K9IMIT7E-vLMIfgtmp4ir-rN6htkxtM_hnpdK6xN4V16IzhTsAKnkiy2g
Message-ID: <CAPhsuW6tG20xWmjK9PxeW53ybMF5EL+zu=URpQ=VM4fyBqROWw@mail.gmail.com>
Subject: Re: [PATCH v2 32/53] klp-build: Remove redundant SRC and OBJ variables
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B79D24ABB78
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2681-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> SRC and OBJ are both set to $(pwd) and are always identical.  The script
> already enforces that klp-build runs from the kernel root directory, and
> builds are done in-place, making these variables unnecessary.
>
> Suggested-by: Song Liu <song@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

