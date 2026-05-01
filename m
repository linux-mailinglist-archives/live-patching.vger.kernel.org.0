Return-Path: <live-patching+bounces-2683-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CHKHGKF9GlmCAIAu9opvQ
	(envelope-from <live-patching+bounces-2683-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:50:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F09934ABC01
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86A3F3019173
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B172239282F;
	Fri,  1 May 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQmdD1hC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0E5239E76
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777632607; cv=none; b=SlWbfr4lX6XChFgjrKRW3XXsfnLXn+Surjg7jMXZrXDNfWxkybnPyo7hTSR4oAVAMSQEynaT1m3QXQBinB2WWHldZfLOVflNXBVxB2ZnGl5g0Gla8vHM5AHqf9s1KRlHJrN/5S7CvIMsmAoywa/6OqHilBJCitITvEy/pxyd/sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777632607; c=relaxed/simple;
	bh=+8zMuXwdfAWMvPH1Ztme71Uqde1w2/N+iHu05gGh/1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aupjwDNLpb70pYjjXLPDLOGSh/3kXUfFdxmmZYnVNLFeZ4R/WRti/Q2KLf9cFEhtUM2MGwC/hqrEjwB5Tqf+z7KGZ4JJZNjF4VPDrALIlt9du/1btNn6HtB03TmMg4q7E8IsN1o8FFUBj08s2aZ0Ztcw6PKBcnSRiNhXLJ54BLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQmdD1hC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66514C2BCC4
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632607;
	bh=+8zMuXwdfAWMvPH1Ztme71Uqde1w2/N+iHu05gGh/1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iQmdD1hCkZzsTy0CpaDFfLLngUjdabfsxx5Eus9i1akMsA7tJgiBETCM8J2NmnG5W
	 pWCyTEYyPsR325940yknl4FtgRDIZTD8HK2rFwQ5PDckFNNCctm+6iCmcW5dxY7Xut
	 gd8t25YJzzsXDd0Qu6e8l5pQuQlPvP+VcdpJncMzSrV76YiZcDzkH/64iTfV2q8rMF
	 7WEAKYMv6bEa4uGnS6lis9Aw9k3q0AN70hWxKM/qZb4B/FoZI/nIGUrLeNwYixqCsT
	 OGo8lG1mdk2VaP20STImesSr7XCU4BKNpfAb9YU3XDwDLpC0JGIIs9BWD+K5U3jXDD
	 drWEPjy/+NiFg==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50e5ad864a6so18809121cf.0
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:50:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8X25FPElwHjEF2sIrs99zJf6t8ziXziIfnJXf43wRHryris5DKaWQn1xnPeC4lrxYfV2ccAC8a149IxNum@vger.kernel.org
X-Gm-Message-State: AOJu0YzRrJWDZKyD2wh6679MzvNBc7snffyTVKX5yf7/GUrC3DcY7Dw3
	T2nXNYgSbq+mcN477gcaKpxSpSRMxQjRfNw7pJLGWuBKSJ+AcAmG8D6m01nTJZ5dVs6vODNdvrg
	9ZGwuYHfIc5UC9XavtqLNGMGtOGpK7Fc=
X-Received: by 2002:a05:622a:90c:b0:509:39b5:a97f with SMTP id
 d75a77b69052e-5102ada8975mr93112461cf.29.1777632606612; Fri, 01 May 2026
 03:50:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <ec40bb551a583c7a7c329199e41d21a0f086775c.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <ec40bb551a583c7a7c329199e41d21a0f086775c.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:49:53 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7wWktjvQBzi_-O-15cE0sSuBPfTrQb5oy3xBODogakXA@mail.gmail.com>
X-Gm-Features: AVHnY4Ipp_EYsh4oE96vw_8i3vEggYiHuVDKx6whY_-OxCQfAkS1KGRwG7NWG2s
Message-ID: <CAPhsuW7wWktjvQBzi_-O-15cE0sSuBPfTrQb5oy3xBODogakXA@mail.gmail.com>
Subject: Re: [PATCH v2 44/53] klp-build: Validate short-circuit prerequisites
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F09934ABC01
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2683-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> The --short-circuit option implicitly requires that certain directories
> are already in klp-tmp.  Enforce that to prevent confusing errors.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

