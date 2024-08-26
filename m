Return-Path: <live-patching+bounces-516-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B3495E752
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2024 05:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C755E1F2170E
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2024 03:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39FBFC08;
	Mon, 26 Aug 2024 03:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvAD2m4I"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7E0B64A;
	Mon, 26 Aug 2024 03:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643100; cv=none; b=Cm6CF7b/PXhVPQbwiWWuysFF8Fc0K3XIGFlbLRa7V+addS51FMs22zZ0uXQ87Y4xqjFs3THtvpqpV72GfvCTwxPmVlSPs87RQH8On8SEf2JzJT9Xv+5zn4rQNGC4HmU+JvDkw6VB79fSX6BgenUKiEFslsoLvqXC58jvv7Vma50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643100; c=relaxed/simple;
	bh=hU6ZkN6uaJUG/lvOYKBOrkXIuPlwxW2VXkGjuiD/PKk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Y/ZxpUb98bEF9CcnZ8WBzG9+SB4p2ulyZTdvUKMwrJzKcx4kFWyKxPe2cDXmVWVd3gAvCyrZGaMtp/JKE0R2kAKTBWcW7y2Xi58C/RqjFtp0nFHUTJyVdGRjKNngAtMqvgxACRyKA4pOQe7wu56TForfFl4VlPKPlXv4PQI3ibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvAD2m4I; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d3e44b4613so2706524a91.3;
        Sun, 25 Aug 2024 20:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724643099; x=1725247899; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hU6ZkN6uaJUG/lvOYKBOrkXIuPlwxW2VXkGjuiD/PKk=;
        b=lvAD2m4IvFeIKRydrebqQ7IJhOxhO2JL1Ee5vTA0IsmWzKmUnaN4K2OE4K82gMX0tK
         tRo8Nwr6ccyVeQXFA/eIB4e1LdayDm/rI5a8RqBPRHnSNYqydzHyXYjL1nz2KlEvi6Nv
         gLJX8H1rvfl5rQ4I6USf4c1mnU4t5Wzs6+Wep9k+GfsBG74k1LWQxihaME+upWr1Kt9n
         TgyFV+dCKw1VsoHpYfzIA1qq1wsthfM7OOFSc6HMlwSQ6WcEmzN2wNRfn4B7tRs33lv2
         VCWQ6PEMz6VD0wFMG2MA2nEt0fy8jnq5kdYY3T1zs29XyspdZo4A2FmbMKAwiYdi8T8A
         XcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724643099; x=1725247899;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hU6ZkN6uaJUG/lvOYKBOrkXIuPlwxW2VXkGjuiD/PKk=;
        b=giolMpDV8t9lEeI046PMfaHYKTrlPIo2zNo4oBaEb9Gp/9TXKLj7iYPsZxt/DwXR0L
         PecoPYtrK5vX9kACylKmFrivbaqlw31z7ZOKsrqFBf/1jh6zXGfp7H7tkhtYVX5SXCS6
         rdwYa/CpXSrAbg6eUF3yiGsp70kEUOsZh5u3cKdw8GLjeGuwPQi9YFo/pREkNl0850Qb
         1OcXmRlPD9r3fY2yB1VSPl6gQtvxhG0pMHQnI41t5qxKWTyZoy0976PvPP8XaI+ahSi9
         lniDuNEGF2y6sYb9mRk+lQo+b1MDK7eooqUFY/QjpDSTkj/5O3TQLmpLAgktZFwR/iGk
         P1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCbN/Pvyl9ZLT0JuirfFy+kqBP+pcAGzM/P1ScsHbZNs2xe1kONQbQJyMFlbk1dq0exgYeM1f/dKB62yE=@vger.kernel.org, AJvYcCWuNP8PnrCKOrcT8k2vCU+TFH8DwEDEYHc61TXRdBEvmDg763QBhnd/4WdsmrlZBZhnIYCeE9Aj/ZkbA4vLHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZQaKN6a3kYOgeyVfa4KeZkckQCEM5jU/e6IbCb01ey7vaWBQK
	ZSJdrBQsJOIl9+QmuBVuWfbrKv9aX2dqKgDdayIvHmulSMfrzKcL
X-Google-Smtp-Source: AGHT+IFE70VUGhRQSKA6yn3oNdAUiOQp0vs1jxBVLACAwoQWLLp1zi3PUyZdMY06clAxdbtyWwyniQ==
X-Received: by 2002:a17:90a:c718:b0:2c6:ee50:5af4 with SMTP id 98e67ed59e1d1-2d646b9fed9mr8189635a91.6.1724643098667;
        Sun, 25 Aug 2024 20:31:38 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5c2e1ad3fsm7922588a91.1.2024.08.25.20.31.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2024 20:31:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v3 1/2] Introduce klp_ops into klp_func structure
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <nycvar.YFH.7.76.2408252216300.12664@cbobk.fhfr.pm>
Date: Mon, 26 Aug 2024 11:31:23 +0800
Cc: Christoph Hellwig <hch@infradead.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E00E609F-FD3B-45ED-A1AF-84212B60AE68@gmail.com>
References: <20240822030159.96035-1-zhangwarden@gmail.com>
 <20240822030159.96035-2-zhangwarden@gmail.com>
 <Zsq3g4HE4LWcHHDb@infradead.org>
 <C3B45B71-C7D1-45EB-B749-39514A49C521@gmail.com>
 <nycvar.YFH.7.76.2408252216300.12664@cbobk.fhfr.pm>
To: Jiri Kosina <jikos@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 26, 2024, at 04:17, Jiri Kosina <jikos@kernel.org> wrote:
>=20
> I believe that Christoph's "Why?" in fact meant "please include the=20
> rationale for the changes being made (such as the above) in the patch=20=

> changelog" :)
>=20
> Thanks,
>=20
> --=20
> Jiri Kosina
> SUSE Labs
>=20

Hi Kosina.

OK, the relation on this patch will update into the commit log in next =
version.

Thanks,
Wardenjohn.


