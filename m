Return-Path: <live-patching+bounces-289-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7088CE216
	for <lists+live-patching@lfdr.de>; Fri, 24 May 2024 10:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0087282E46
	for <lists+live-patching@lfdr.de>; Fri, 24 May 2024 08:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D21D128829;
	Fri, 24 May 2024 08:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZKeI0QRq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6682D9E;
	Fri, 24 May 2024 08:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716538395; cv=none; b=ovPj2E0dJecWhrX+evwIhGxcSr+oBz45imck0eksrb94nkFr9GkTd7eka6Z9Ekzq24n+jgRBIN5axDap+/JTrflxTqLkzq5s52PW5Jj9gylmPAmiB4XznZfJKGq5H26q/phtfp+Npe7X5/Mz8FhxaFS7T/6l+03u2OU8EWU+vh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716538395; c=relaxed/simple;
	bh=fo/HifB1DQNO6ydXHHI68Oeno87uAoG3bcpgtwEUM38=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=N1gbRFrzPFZAe1cuQymy34D8RNyoQdyj2wzbcNO81NcMauyK3Z4EtJ5AG2+2bOoLxMGgEKgJAnA2AvDs82gil8l0b83hrjjZfCnjMhdKlpjdZWqakl+r/pQsQkSbvyonB7WZo4goIzrQDg189Ovp+3jhLMAQEMnoek3+nBfVmFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZKeI0QRq; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-681adefa33fso471140a12.3;
        Fri, 24 May 2024 01:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716538393; x=1717143193; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo/HifB1DQNO6ydXHHI68Oeno87uAoG3bcpgtwEUM38=;
        b=ZKeI0QRqyqCTzZfLVZlzTX8ncE623VO8eFay1ruW3Iyaw4VjG8KorQdWGjBV6/dvWR
         GA76/LZZedjebMllXPIyuyIurQ0RYlr0EzKUVLgJuUr09qGhrcDxTpR/f7noYmb7+p5I
         KCIaZjanZSzsg/vWhhVJNYjl+uLCH6k/otvLSCzH2h8lluZ4KKUmRuPbY/YooYzSBG73
         7gstky6hkEYl2tMhV2CZDVoDAGdZWYO2Q5TbV/mFceeGfSm8bO/Ecq5tocT2CFCMIuBk
         U7dVup8yTBbI9CMfOXisxsLhX+h3prXUYiWmg77lVPvvybVSUzaNpQOJg/7gA65dxuRE
         LMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716538393; x=1717143193;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fo/HifB1DQNO6ydXHHI68Oeno87uAoG3bcpgtwEUM38=;
        b=nZL+koACKzYpdCVFkQQSHnEDYV7p0DYLU+uyA0eCdWUN1WIBxVcgwekicLaB9dqplf
         8/o0vpIW9FRXxjSjZ43GmwIui4EzypjpdyNniZ/2havVfEzOCb0xAp2v1X2pskE02wv6
         xewFX9W9PyxQISBTWxi3/ygf7MGW3R10QvExuVdnuyI0lMJjb2iIw3mkfkrC2w8el90/
         FjZuE3G44/uQzraiPnsi2oKlJAAMxfY5AAp9A1TxP8tEdW0eYjdgAfBcXd9c6OzHPfPN
         sf78K92pxPZKLMPXQdPbvSB55aPPxT09Wxl0t/ZtoubOFlt8YTZS3H/IBj/rmMNkgZRQ
         /mDA==
X-Forwarded-Encrypted: i=1; AJvYcCW6wNJrG1Y3ZsqnisaEWDpqymRVr/zOftfBQCIb3jWgdqA5sCJEPy7OU9b2JBM1ilQ1M7m0Ycz0ORgWyHi8+orQqEvrbzY17Z55S8e/D5BuWe7AcZMPjDPgpvlenqyvIyUVbpYyCn1XY3oOjw==
X-Gm-Message-State: AOJu0Ywi2AXQmA/yIHR0vQ6sz0w+Ls5W2EPr28ZnCkkWaafDLuY240xD
	gWTgMcaBHXYqNYP8Ae2yRe7GwPl2QYuLmiazLItnBMWR+YkKM8zQ
X-Google-Smtp-Source: AGHT+IGbCexb9JcS2vxVXdyF9SCloZlJhV8n0Dyl9yNgd+ElrVUuh6fh4jCb/R72rcy16Ts1QFNnZA==
X-Received: by 2002:a17:90a:be0b:b0:2b6:c4d7:fc31 with SMTP id 98e67ed59e1d1-2bf5f719ce5mr1726860a91.40.1716538393006;
        Fri, 24 May 2024 01:13:13 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f30aa26sm848060a91.6.2024.05.24.01.13.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2024 01:13:12 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <18994387-2d2f-41e5-9ef6-6541dd0015d2@moroto.mountain>
Date: Fri, 24 May 2024 16:12:57 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C317446-0259-445B-8AE7-D91E1E5ABF93@gmail.com>
References: <20240519074343.5833-1-zhangwarden@gmail.com>
 <18994387-2d2f-41e5-9ef6-6541dd0015d2@moroto.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 23, 2024, at 22:22, Dan Carpenter <dan.carpenter@linaro.org> =
wrote:
>=20
> Always run your patches through checkpatch.
>=20
> So this patch is so that testers can see if a function has been =
called?
> Can you not get the same information from gcov or ftrace?
>=20
> There are style issues with the patch, but it's not so important until
> the design is agreed on.
>=20
> regards,
> dan carpenter

Hi, Dan.

This patch have format issues as Markus said. A newer version of this =
patch is sent which is checked by ./scripts/checkpatch.pl

Thanks for your suggestions.

Regards,
Wardenjohn


