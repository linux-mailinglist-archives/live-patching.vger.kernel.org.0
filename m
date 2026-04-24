Return-Path: <live-patching+bounces-2524-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHbnLnLb62kgSQAAu9opvQ
	(envelope-from <live-patching+bounces-2524-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:06:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AE846366E
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33E3B301C6E7
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC6231F99D;
	Fri, 24 Apr 2026 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAwreTiH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7492DD60E
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064816; cv=none; b=tWVGxTZuttHUAAlMAdPAUpvHtmZyS+kXnhNojllX/BbIcTbJBlwHVBTopOQ8o9Vn09IjZIB6n5eWtJsWWmkNTUpZ4dGhpu08r645xHT4jKoOaVrw1KATOLcPrWMkM4jcRs3KLUefaOtZf7g3qDywGKYPxj8uJrqetH4lrmOQNh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064816; c=relaxed/simple;
	bh=Nh8QtgSyVZwGWzK0Myx+xWNtSs6J3HikaYR3W4w7AO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IiyzMr4n5gr7vHxhMco7coNiJkkbhLTKCiqos5oCUfyUiOB1CoTb7qCuCEp/mwjvwf4WwKwSSqI4sLzLLcnIOnbCrgu/XwqA87TqPxcoQ1OvhK0TRuHb2CXrmwV0EABhfpJaTpt0Uk6I5F5ypWTkIiuAOu51xVyLBaTwIafASrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAwreTiH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D330C2BCB7
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777064816;
	bh=Nh8QtgSyVZwGWzK0Myx+xWNtSs6J3HikaYR3W4w7AO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lAwreTiH4ncMcLmDpuNhZpzSzHU4VMZOVKR2+iLlpIn23OL/OtPlAp6Lsp8yVwYWe
	 5mYAr+au1v5pOajl4httXKHo5RY0Xhw8lF/Irs96BQ7ixdjqfO5agg0EjLJoxyEz5W
	 Yy2mtSi8g0+ZVMvyROn7BkABEmwg7lNHQcpdH+ql3B974EJpNzv18FgJ+6oN6Sv1VA
	 BzkCoBtkpObTy1ILboZ3dL85insXyS5owW1ykLIwd3/T/665y8TLXv74EsLlzVvLD9
	 r+ppq4qWRxcBOQ9HnV+gmWmv3nip+kypyVzmf68/lQfuJmrP5YjfTD/NznW2/x52u8
	 CUdBoLD9ZaSfg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d736211595so551221385a.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:06:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8qNUk6HOHZ+DDN4XVya9G87XY5nnphM5GGppkWwnWw1aKedYuYVv5wn5BadMoXbIM+itzcmakbDuLo5+sI@vger.kernel.org
X-Gm-Message-State: AOJu0YwiVeFDhXLU2ZyuXccPJto4IP0n2ZJ7ZXvCCQbn31ZHM0s2H6Vg
	5Xc8xlKPGBWya1KJCyuXsHDW2fJA/E3ivhx4FyZ13tZCiJjVbHsXc+m8fM744DLxii9Nh4O4rs5
	//UdYrMw+cYAia3DB96nfEpLarxzhdgY=
X-Received: by 2002:a05:620a:7118:b0:8ee:21b3:2e9d with SMTP id
 af79cd13be357-8ee21b33197mr2701644385a.60.1777064815421; Fri, 24 Apr 2026
 14:06:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <7fd49264db4f5a9c654ad162cca96ce575e77ae4.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <7fd49264db4f5a9c654ad162cca96ce575e77ae4.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:06:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW54oeRzcdoXMQxA29ZxUSyHN7U4pjOn7iEXZ-xt02MRyQ@mail.gmail.com>
X-Gm-Features: AQROBzAHWEVWZKB9UpPKoS6WjwVuIN8k_9xoLgm4cbJUYAt4bNc5fOewaBiOWec
Message-ID: <CAPhsuW54oeRzcdoXMQxA29ZxUSyHN7U4pjOn7iEXZ-xt02MRyQ@mail.gmail.com>
Subject: Re: [PATCH 10/48] objtool/klp: Fix --debug-checksum for duplicate
 symbol names
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 36AE846366E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2524-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> find_symbol_by_name() only returns the first match, so
> --debug-checksum=3D<func> silently ignores any subsequent duplicately
> named functions after the first.
>
> Add a new iterate_sym_by_name() to fix that.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

