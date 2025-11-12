Return-Path: <live-patching+bounces-1840-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A28AC54A3A
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 22:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3ACFC4E1135
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 21:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7654C27D782;
	Wed, 12 Nov 2025 21:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRTpdi48"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C394525783C
	for <live-patching@vger.kernel.org>; Wed, 12 Nov 2025 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762983576; cv=none; b=Xf2T9dHQwT+QlqkHKOL+I4qb+Awe4kyNHFNYLSg5A+N9Du4B8Pt0O5ZpaiJ7QTwC0sODM7GknKaWrd1HnzXhjxCW9toOSLoVe6JLfxPpkSMwvL1paDk1t4UYH8QTsJK+tBsy8Uc8ilK/jkhct7nCqfVa6D51FrywUcYJMbV78O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762983576; c=relaxed/simple;
	bh=wntAcgzyDrtiqse/RUz5AXoDK0FgHwu+ULhBxcDFZn0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PU3p2uiNXAnbESXsZa7neSNojqeUyvlGlaTJBT/AidtyK2uKpc1mah6Ks8fl06p7HrZEImNauZmYm3gSphncW2g5hZPWHE7LJ0u0OcLO98PuQvs7BHbDG7Epc9dzWGXbghfQRX1bLeXseXwT0A6uB3yS931bKsxhVwIeVt0IVtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRTpdi48; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47721743fd0so948235e9.2
        for <live-patching@vger.kernel.org>; Wed, 12 Nov 2025 13:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762983572; x=1763588372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGZxehFBUyH3uRklLTF4LfK7Gkk9FQHMs1jsZdMbm9U=;
        b=nRTpdi48GfS7DzwBEvhmPv1tNzcGPSScBzvMaSR4dbzqqwmLIzPXTefMYol/z9Oe8l
         NhvmyD0hGm2l1DFxGyosOLeEIyIQzxU2/SJQ9PDTwx31p4/J2HhOD+MeglJUTrkmdKhh
         Cd2Yuy5xPjH0U11D1Ual/OqVJkO0IsXwYANR2h3CaB+JIZUNlFCn+K+yvh1InrDM7yhP
         8QL18xYVrP07oJu91ediODbhX+SGOr0TC/D91+VUgF3JSCzlRvWk/6cDpnAhtW+6JQ/B
         ijSwXOidNYQOp2/6WKAygzczebJgR9ZR7alS+xgxQ/cw/Vw08OhNiEQpKxls38wOBTnB
         cm3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762983572; x=1763588372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aGZxehFBUyH3uRklLTF4LfK7Gkk9FQHMs1jsZdMbm9U=;
        b=ZdFiD0CYJchmWKp37j30jKHxed780W5Z8gIAKmziZvl6bGhO82uvfZsA5veu/MDxNX
         lUMSlssMEWlx9JqElCqNVoaC4ioSpTGcn+eKeEcyvojpYT5yWNBlqGS0rscb/w+7GlPD
         OO2gj3+RXETHBmB14ob5VUkb0r1WWGCmv2nS77jzpbUPd5WOmsXkt0OfPhRmtogudu69
         s19PI5C7lxBun7YHwH++hqru5SatJPzLO8TeMu92BpfYRSn+jaUBHH+aJitC2go4xWJO
         h4FOaVrGUkG0Lm4D1+tGPLDSOpn64QztcDrGX79unPFnsiXKW1E+RkuZJLyTDISrdv3+
         YmTw==
X-Forwarded-Encrypted: i=1; AJvYcCX+NQNRnk6OG7JMTHhamfYouNBsraD6/JU/OaloD4pzTH7T4epZMkDDGHr8wkVN/RYa23bo+afXByI6oZn4@vger.kernel.org
X-Gm-Message-State: AOJu0YyKeiU8V9k2HfdFvNwUmqZyW34wGdVFFcVEc5fDX5fm63G+XbmY
	pKXRvsWoe7Bolo5MO5AGOSY9NEoHZfKb+RxyUeGbvLlyWnXEZ3ZJ2/gK
X-Gm-Gg: ASbGncvtpDuT1dKCGxXPTlXRoBjIYZEsOw6RNiIb6HeCa0+N6h1bgb/zDDyQ8Jrc9rF
	1sB8B2yrdNy+63zneLF08WrwJeuSSYrjR/m046AHj8xLNu7AeH5Rff69pHQCBlhxWKP+DXCIf/L
	dATQKxleBhGrfZBcdNHWw12XVMwRorOEV+rsE57Jdjkq0GRUO2WHBF+h62mgV89QkIWqC/z9MGf
	KvPBOj5nUIhN78Gjt3yYeqtYRpOjaNAwDw0UUsvg5VVDWyT99BU6eJdbaFambXDURRM+zMBXnmC
	W401wp9lJ4V9d7b1W3FS8+QacSRE9wjo3wfeYfk1JuZBOvjj1riQzxcdwC6ilALUZI9beJzxsKl
	e61PbDisuxNBeLgWD0ZOmYRhNDCIgcHiRVkUlGp5UucZeGi54pBVEvugf830ed32RxBcQTdg3n6
	N1D6FgdzR1IbwHLXidKK/LxAQiyQ/Rk4PEs0MP0tCKZ+N1445Cim/5
X-Google-Smtp-Source: AGHT+IF+PXULQaEGJZ+cq+ddTyZ8MaiZsGG+WaQWCmX7nBuDQO/G79xCT621oYLasi7kW4ILjHlg7A==
X-Received: by 2002:a05:600c:450d:b0:475:dbb5:2397 with SMTP id 5b1f17b1804b1-47786ff9065mr38233535e9.0.1762983572019;
        Wed, 12 Nov 2025 13:39:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e43c2fsm52087835e9.6.2025.11.12.13.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 13:39:31 -0800 (PST)
Date: Wed, 12 Nov 2025 21:39:30 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>, "x86@kernel.org"
 <x86@kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav
 Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Song Liu
 <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina
 <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu
 <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin
 <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, Dylan
 Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <20251112213930.11915727@pumpkin>
In-Reply-To: <tujcypul6y3kmgwbrljozyce7lromotvgaoql26c6tdjnqk4r6@yycdxcvj2knz>
References: <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
	<SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
	<SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
	<6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
	<SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
	<yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
	<BN7PR02MB414887B3CA73281177406A5BD4CCA@BN7PR02MB4148.namprd02.prod.outlook.com>
	<20251112132557.6928f799@pumpkin>
	<tujcypul6y3kmgwbrljozyce7lromotvgaoql26c6tdjnqk4r6@yycdxcvj2knz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Nov 2025 08:16:59 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> On Wed, Nov 12, 2025 at 01:25:57PM +0000, David Laight wrote:
> > On Wed, 12 Nov 2025 04:32:02 +0000 Michael Kelley <mhklinux@outlook.com=
> wrote: =20
> > > From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Tuesday, November 11=
, 2025 8:04 PM =20
> > > > On Wed, Nov 12, 2025 at 02:26:18AM +0000, Michael Kelley wrote:   =
=20
..
> > > > Does "$(pound)" work?  This seems to work here: =20
> >=20
> > Please not 'pound' - that is the uk currency symbol (not what US greeng=
rocers
> > scrawl for lb). =20
>=20
> While I do call it the "pound sign", I can't take the credit/blame for
> that name it as the variable already exists.
>=20
> It's better than "hashtag" which is what my kids call it :-/

'=C2=A3' is a "pound sign", '#' is a "hash".

	David



