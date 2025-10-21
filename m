Return-Path: <live-patching+bounces-1782-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB081BF4C89
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 09:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EC803B3726
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 07:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C870D261B70;
	Tue, 21 Oct 2025 07:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ew.tq-group.com header.i=@ew.tq-group.com header.b="SPjFBNKP"
X-Original-To: live-patching@vger.kernel.org
Received: from mx-relay19-hz1.antispameurope.com (mx-relay19-hz1.antispameurope.com [94.100.132.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8294E257820
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 07:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=94.100.132.219
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761030066; cv=pass; b=mZRQFQgTP7A+WE2p3Ex5vUyy6lFOh8jj/IqA0WuzMMxoptgJrL/hlwYls8Fq5m9/TDI2qDxFrn2K0vHTFdtmmLLlh+EZ/suK/P8f39O3+McNYCwNqfxDOwM/myv0IfYoW7x4RqGyAVluWwpT/QMu2Luxty39euf7N3Wrzh5XgH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761030066; c=relaxed/simple;
	bh=Q8sTHyOz97Zfu+JuJfIb4G6hqQA+e+s0O6Mbm0Jd0UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rIK6OmnRYKs9dfzhWh428ozR60i6jSgH0LUOG2Q2JURFWnQmpJHq0f0GUHg/Yo7hs1Ih/z3DvWTfTkDXIm/LGKryFM9YYh1vjeQMTXtNV3gNnKBdi4LZgTQ4a3ZOm+d/tTxThSASVcMNiLPGNTHUuUyrAD+btMD79pA6vNabn+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ew.tq-group.com; spf=pass smtp.mailfrom=ew.tq-group.com; dkim=pass (2048-bit key) header.d=ew.tq-group.com header.i=@ew.tq-group.com header.b=SPjFBNKP; arc=pass smtp.client-ip=94.100.132.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ew.tq-group.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ew.tq-group.com
ARC-Authentication-Results: i=1; mx-gate19-hz1.hornetsecurity.com 1; spf=pass
 reason=mailfrom (ip=94.100.132.6, headerfrom=ew.tq-group.com)
 smtp.mailfrom=ew.tq-group.com
 smtp.helo=hmail-p-smtp01-out03-hz1.hornetsecurity.com; dmarc=pass
 header.from=ew.tq-group.com orig.disposition=pass
ARC-Message-Signature: a=rsa-sha256;
 bh=RXCPO1Vsv8GCMq7O/Lb/mclvihGadUe/ChieUPYMtvE=; c=relaxed/relaxed;
 d=hornetsecurity.com; h=from:to:date:subject:mime-version:; i=1; s=hse1;
 t=1761029982;
 b=dntfRFgqwRs6AUNP0JV+JINUQVUAYOFcnHcFB02oqbFXN/47EYTUufEbiiQM9ygV2UH6PIEh
 /z82XxPVziznDOBwurvti6uhmtknxAI2jNxw4ko6SG+jEfqtTiEq0cdhgpJ3t1bcBm1xs+L3Psy
 IiDyPaqT6lCFDzL++eCUvirr7AIG/zMtofgxfismuYeHZ5cEFQgg3VRr7fPDmK/9iVndiFM0kKR
 GRI9ZYP9CC2I1q0h8tueRrphT1cWe+YG7vhniPd+/IphMsGSW3JrS453JZdjbWfE8ycxGvPnHsD
 /OSV+SUCBI2/VTop0LhKSOMUp5hsqnNw+asuTHXl2fpkw==
ARC-Seal: a=rsa-sha256; cv=none; d=hornetsecurity.com; i=1; s=hse1;
 t=1761029982;
 b=bGe+wv4Fus1bXtOgHvqKKwgkSRdb6YHRtgdDvfobT1b5+Rxw6sy0zJsAqghdCfXGVEJvOgWn
 CGBAJGm+pHnaMuvDvJi+aaDNOhvqgLKG9dxuyp9o7vbGtzIozQTf9rDNqsZyJXDswMHSSv2nPwn
 LNoZ7g8B1ckNwHV15xM6Qvjt+M39HTVbJkkS8vRk5O6VBNkCIGLMV6mCi4hdKe7GrYFN8VMPbbx
 AT4k5/p/CBYeesBlti74T3Vyql5SRbSXXgxUU9zQzx0wXHQ6t7eYTPpkZ1PRhHTgMqb2e4qvCav
 1mBbiXLwgUSilBBzbv4eZcYShW3C5vUTpPqYyj1H1/bYw==
Received: from he-nlb01-hz1.hornetsecurity.com ([94.100.132.6]) by mx-relay19-hz1.antispameurope.com;
 Tue, 21 Oct 2025 08:59:42 +0200
Received: from steina-w.localnet (host-82-135-125-110.customer.m-online.net [82.135.125.110])
	(Authenticated sender: alexander.stein@ew.tq-group.com)
	by hmail-p-smtp01-out03-hz1.hornetsecurity.com (Postfix) with ESMTPSA id DEEA8CC0CC7;
	Tue, 21 Oct 2025 08:59:21 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: x86@kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>,
 Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Mark Brown <broonie@kernel.org>,
 Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH] module: Fix device table module aliases
Date: Tue, 21 Oct 2025 08:59:21 +0200
Message-ID: <5024487.GXAFRqVoOG@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To:
 <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
References:
 <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-cloud-security-sender:alexander.stein@ew.tq-group.com
X-cloud-security-recipient:live-patching@vger.kernel.org
X-cloud-security-crypt: load encryption module
X-cloud-security-Mailarchiv: E-Mail archived for: alexander.stein@ew.tq-group.com
X-cloud-security-Mailarchivtype:outbound
X-cloud-security-Virusscan:CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay19-hz1.antispameurope.com with 4crNSp5ySrz3D7KX
X-cloud-security-connect: he-nlb01-hz1.hornetsecurity.com[94.100.132.6], TLS=1, IP=94.100.132.6
X-cloud-security-Digest:7e70561755faed15dce06a351d980bd0
X-cloud-security:scantime:2.178
DKIM-Signature: a=rsa-sha256;
 bh=RXCPO1Vsv8GCMq7O/Lb/mclvihGadUe/ChieUPYMtvE=; c=relaxed/relaxed;
 d=ew.tq-group.com;
 h=content-type:mime-version:subject:from:to:message-id:date; s=hse1;
 t=1761029981; v=1;
 b=SPjFBNKP5q6LujSBGHsmU09L7Yncu7128YVPiZezEH+Y2BqLx+rYA+rV/F/ui7CVIFAdnX04
 CjE0Da6TKr9nprJe2qfrRc4j/dTHNzYL4GX2VNaTqWDC4Duhww0qD74KWPRFWde4c+oSlKpbSeW
 4WHkKvcvk2vaT78HpmaB27rkibuUNmhrWSOI6aBlDgUjBxvCGuX3FQpHDHwORH/zAm24cRxaKaN
 MBQnJbrF4WRK2UhJGolyJC1x3SBg8I68h+pO7Zaa8NQB+sTAtJEPu84Yl5EKQRrKDshDli9cPrm
 6iPXmBc6wrcJobkRp8AfEPkKSaoY+aEg366hD+d7fOfRg==

Am Montag, 20. Oktober 2025, 19:53:40 CEST schrieb Josh Poimboeuf:
> Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> __KBUILD_MODNAME") inadvertently broke module alias generation for
> modules which rely on MODULE_DEVICE_TABLE().
>=20
> It removed the "kmod_" prefix from __KBUILD_MODNAME, which caused
> MODULE_DEVICE_TABLE() to generate a symbol name which no longer matched
> the format expected by handle_moddevtable() in scripts/mod/file2alias.c.
>=20
> As a result, modpost failed to find the device tables, leading to
> missing module aliases.
>=20
> Fix this by explicitly adding the "kmod_" string within the
> MODULE_DEVICE_TABLE() macro itself, restoring the symbol name to the
> format expected by file2alias.c.
>=20
> Fixes: 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME=
")
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Reported-by: Cosmin Tanislav <demonsingur@gmail.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>

Thanks!

> ---
>  include/linux/module.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/module.h b/include/linux/module.h
> index e135cc79aceea..d80c3ea574726 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -251,10 +251,11 @@ struct module_kobject *lookup_or_create_module_kobj=
ect(const char *name);
>   */
>  #define __mod_device_table(type, name)	\
>  	__PASTE(__mod_device_table__,	\
> +	__PASTE(kmod_,			\
>  	__PASTE(__KBUILD_MODNAME,	\
>  	__PASTE(__,			\
>  	__PASTE(type,			\
> -	__PASTE(__, name)))))
> +	__PASTE(__, name))))))
> =20
>  /* Creates an alias so file2alias.c can find device table. */
>  #define MODULE_DEVICE_TABLE(type, name)					\
>=20


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/



