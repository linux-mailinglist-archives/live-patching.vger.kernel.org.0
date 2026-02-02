Return-Path: <live-patching+bounces-1965-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEs+Ga4dgWm0EAMAu9opvQ
	(envelope-from <live-patching+bounces-1965-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 22:57:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC17FD1E3F
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 22:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BA193017C1D
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 21:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A108F318ED4;
	Mon,  2 Feb 2026 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnTEPKZS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCD2318BB8
	for <live-patching@vger.kernel.org>; Mon,  2 Feb 2026 21:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770069396; cv=none; b=Ba/MJ/IboLeTZLj5j5LPnLOtUWX3lyo1m29Akdh3WrUxnMz5irt8abFR+xUTMMeHnAXENTQMXoiGGHYjlK2F0EN714puTSZEroeh+ZZrFarSl+dYqOJa4VXVN0woFzOP64u58X4IafZGX2H8+BWmCZFmzbXiodYUWv1sfThRM60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770069396; c=relaxed/simple;
	bh=5AHLgYWBVgXG5Vyrb2RZ5uU9Ofm/rGv76fvDht/whVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RyEqMdo5AjSIKKeNmGWtmmVvMRIIq29e4G8JEIQ5KSMHWpgZBo1qp3QbtnZHsQBE5Bjy4gV++J7bxsQudQO5HURKXz28b/FejIy0HOc2miup2bR5tPw8dWKlzUgwOvvJLhHLLQ9baLIuTOS6Sbq8kUe8kkElEafEA8bCK11zJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnTEPKZS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFBEC19425
	for <live-patching@vger.kernel.org>; Mon,  2 Feb 2026 21:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770069396;
	bh=5AHLgYWBVgXG5Vyrb2RZ5uU9Ofm/rGv76fvDht/whVQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qnTEPKZSxP2fqu43iftFuy1LiUfarfK9wkcwonmq/Vu6k1UZeDnc978DHg3EmAgQh
	 bKGgkp45ys2qiqsnzj47aBBxTtF8dj/J6SFDXS4v5vO608ozQ1I23h7SGN7za7nKbJ
	 d/mr66HYWOeWhGpP6am/p+WyxwR1YFesQAPrAF5SU07vzE5bmUMQWzW0bHegRvJ5qu
	 dqMqDiBKIsm4jJmKq2QUtGO1sVfh0XX5JuOh0Wbgasiy+dW96hfsumUKkQfOMILtfd
	 OsmcMbjwf6JPDgmhYfh0yh+kHjbqcf/8aj9CQfeM4WBiiHchoyQ5wevuNM+neF3O3V
	 0xA1qHHuC7OIQ==
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ffbea7fdf1so47631131cf.1
        for <live-patching@vger.kernel.org>; Mon, 02 Feb 2026 13:56:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVxMWIUNJ6wyk9QkOZ/lB830SNV9qvj4lI5DCIcMbB0FE3vCwG8jt/oZvGn3XMTFwYY+7QuSUKNoQmqnuSW@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Y8csq1NOsWDOL4KN1TpOmKDabbNObG5HLQOl0sjsMTra819y
	z1GbPEhBiHj8d7fJYF1csqq/mK97ZQbL41CmVIVGhnnc4oxOMt5Wcu7M81HvnFM8ODgk9Rc//oT
	wpO1fow9NoR3X8ZJgun5aTwvxln2g0gU=
X-Received: by 2002:a05:622a:2c2:b0:4f1:b947:aa04 with SMTP id
 d75a77b69052e-505d217c778mr172940411cf.18.1770069395349; Mon, 02 Feb 2026
 13:56:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e21ec1141fc749b5f538d7329b531c1ab63a6d1a.1770055235.git.jpoimboe@kernel.org>
In-Reply-To: <e21ec1141fc749b5f538d7329b531c1ab63a6d1a.1770055235.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 2 Feb 2026 13:56:24 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6YtAAdNkKS=c9tJ7M7BonKmsOwop2xmL9+EkkcjhrmpQ@mail.gmail.com>
X-Gm-Features: AZwV_QhSdh_qaej1UqAK-D96t9vzsnLya5gCp0S12M2F8qRbjLRTYFAwV56EbvA
Message-ID: <CAPhsuW6YtAAdNkKS=c9tJ7M7BonKmsOwop2xmL9+EkkcjhrmpQ@mail.gmail.com>
Subject: Re: [PATCH] objtool/klp: Fix symbol correlation for orphaned local symbols
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1965-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BC17FD1E3F
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 10:01=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> When compiling with CONFIG_LTO_CLANG_THIN, vmlinux.o has
> __irf_[start|end] before the first FILE entry:
>
>   $ readelf -sW vmlinux.o
>   Symbol table '.symtab' contains 597706 entries:
>      Num:    Value          Size Type    Bind   Vis      Ndx Name
>        0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
>        1: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   18 __irf_start
>        2: 0000000000000200     0 NOTYPE  LOCAL  DEFAULT   18 __irf_end
>        3: 0000000000000000     0 SECTION LOCAL  DEFAULT   17 .text
>        4: 0000000000000000     0 SECTION LOCAL  DEFAULT   18 .init.ramfs
>
> This causes klp-build warnings like:
>
>   vmlinux.o: warning: objtool: no correlation: __irf_start
>   vmlinux.o: warning: objtool: no correlation: __irf_end
>
> The problem is that Clang LTO is stripping the initramfs_data.o FILE
> symbol, causing those two symbols to be orphaned and not noticed by
> klp-diff's correlation logic.  Add a loop to correlate any symbols found
> before the first FILE symbol.
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Reported-by: Song Liu <song@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

