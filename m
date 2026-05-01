Return-Path: <live-patching+bounces-2684-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AvNBSuG9GlvCAIAu9opvQ
	(envelope-from <live-patching+bounces-2684-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:53:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2D74ABC64
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E88DE30193A1
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0033859EC;
	Fri,  1 May 2026 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DducsEDU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2332F84F
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777632807; cv=none; b=be8uBsjRagQS2cHGSJFAXTT7hunrudROJ+/rj6lJUNcfRWAe+z0SJI8kZZw2+Wy6r10vsTltDdUacIVsUn4Q5S3mjx8NW9bhJ5wDGTL0f4ZosMeBmYxG4V0Q1u5BNna7gt0iYSmT8Vcl78jCBTVSAMu+OYi4UlI/vq8TDokrDNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777632807; c=relaxed/simple;
	bh=1hB+uQtyler+1LQ10DnLFZO+BJmwFpuhMkb9unjLdWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AeB1HFDRp5fNV8ZOmp6wrwW8cSUmaJVKmAAn5zHJf7o861jWyG661nwdmqMSn2Pamxg92AfUcQBjoHgvYG1PtDrzT2/WkwdgQ/doVYYIN6dwYzssCq4npo9ebVESfiyo6fB5BKYLSDiF8DoyLgGgfhaXUvgzFT/D9AvGeeE7kyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DducsEDU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EF7C4AF09
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632807;
	bh=1hB+uQtyler+1LQ10DnLFZO+BJmwFpuhMkb9unjLdWg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DducsEDUj33Wx/BwUErcmp9RtnFmBYWizencz8ROX3wavJKCpZwBvFX5P3eVr1UdF
	 uow76A8S6T1poB1YDYDij2a0HoZtYGsHrjMjF41dZf1vkkKiALJB15dkBe43Hp5Lzy
	 NL9HNOZZQyvZj3wS19piK+YNOZ8xgsc5WYOB7FRKXTfpboGnbEh+uWToicJiyNbAn+
	 D9wAfgU5pAh26K8oZ4+/vupdRy/Bo0AYEv+ETodmJWiZ68/QfqFOgHnAtb6WzB12/t
	 QpgTZIXmDFb7TFBPRWcIyAYDxLsVqHgmLU8v200I9mps1muRIhrlSq6Id8gMajgofP
	 sf2Q8pKfGI22g==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a3b0242631so24297386d6.3
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:53:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/9Nws0WuGf9Kc2dFn31vTg2BLaNTxMqUpRtKtJxJ8Vc+E+tN6TsvTnXSMRGPJ8aWQpUKt7uVq0GpjV3noE@vger.kernel.org
X-Gm-Message-State: AOJu0Yy96zwXyW79+MZWy2VoJPvwKNOIRkMsL5CaaJRSYKCVCT+9MFzk
	VKtB2Xcz53b40slBuLz7HeqfXJKPX2ZWtl2lBiB0onIHDA/cEZdNBncWfQfQOOiCt3FrL7U/xD3
	56zV2BfMEqjNbeFaLOmZOU5VAz/BFPfY=
X-Received: by 2002:a05:6214:f64:b0:8b0:2c81:ad5f with SMTP id
 6a1803df08f44-8b5452d0da4mr39080236d6.11.1777632806587; Fri, 01 May 2026
 03:53:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <88ebcc903a3c534f2c7d35b95f62d845105d40af.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <88ebcc903a3c534f2c7d35b95f62d845105d40af.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:53:12 +0100
X-Gmail-Original-Message-ID: <CAPhsuW5hkNZnKdi6_82bd7+nD=e8aNp3K5uHi+2BM4waSMrvaQ@mail.gmail.com>
X-Gm-Features: AVHnY4IWALTrBgUgP7fUUgOy_9LdsaO9jUqjA4NxQDeejaMzrmUQq0FN7Uf7bVc
Message-ID: <CAPhsuW5hkNZnKdi6_82bd7+nD=e8aNp3K5uHi+2BM4waSMrvaQ@mail.gmail.com>
Subject: Re: [PATCH v2 45/53] objtool/klp: Calculate object checksums
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D2D74ABC64
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2684-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Start checksumming data objects in preparation for revamping the
> correlation algorithm.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

