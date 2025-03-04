Return-Path: <live-patching+bounces-1252-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A2FA4E53C
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 17:13:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDECF17D2D1
	for <lists+live-patching@lfdr.de>; Tue,  4 Mar 2025 16:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF2227816C;
	Tue,  4 Mar 2025 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JnTDS2Ap"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7653B24BCE8
	for <live-patching@vger.kernel.org>; Tue,  4 Mar 2025 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741103307; cv=none; b=DdSRcVKLHG9SJ7mZMoj/0T29OxATC6QD3UfWZfHiiYWhro/FJvuf2csY4vB2Sjn0RlgjlYNvvcgEbwlrlw3lsF8yMmD0WvpxmwGPYcj6Wn7V9E/skt+CGzeTk/ZdKo93n4TjzMpZsOurBlidHw4brifxON5JePWeti3tiM45tHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741103307; c=relaxed/simple;
	bh=Lv7IxLSzan4bEBeBpb5IJ8OPDcDeKbVELqnMeUvw8wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+7E5kXSS1I1O8117pkg47xGLZ2OOhrI+57UjNImW1NHE4B6TyFfRZINtkVHE1DHPZOAahUXHbIyO/NqLi4KvLbJNYb2l6hnbpZ2STXctpN0rSKlhNfRWUufKf4CvSxr1dNL5Db79fVUeZ4N+45HWlq+JlFefxOoIYJv5LCv26s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JnTDS2Ap; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso3075362f8f.3
        for <live-patching@vger.kernel.org>; Tue, 04 Mar 2025 07:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741103291; x=1741708091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZdxOw8yk7OkoGsdvrHglMxlYbwsJWDI+4GGZADxWG8=;
        b=JnTDS2Apkx2zy/+ms5rhakWh+XBaMqaIlsw8xgNOApcjZk4eJCZqz1WhXCbifqs1q8
         ieOWB2xT99U+uom3HczdEYBWWCLj8xw9dUxnNOGu4yCzVL+K3VDPYuv+/TnM3rWRdfOO
         UnS/QGrI8rB7r8zcb/BFK+rfhtmHW2xi9rFdg92y5SuAvoQryGXUzrGIB8bGk1+TD+Ue
         EVHM+yxzqelU8yFdbN1JG+9EyTdDVbk08FmjecLYPyUy2Lvjnacl5FoVFgGRYSU4yWR2
         295TrUTPWbGdvIYH2YWPAeXAa0WBoZ1U1f4JeBeWxP6plszx+PcW7gfzEKMxpqC+CTV9
         f9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741103291; x=1741708091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZdxOw8yk7OkoGsdvrHglMxlYbwsJWDI+4GGZADxWG8=;
        b=fHGaZUdKimg3xIajaTr8Jx3Cnqzs4hS8SL9BLNAMvdTbvXxdlGei3ZUE8OboSYH/PU
         TsWGX+IC47sXkRjPGTw+BVTVD7LfRf25xz+YWiNfnLHHZf37oiM62sCc2muVYM3jfCvI
         XN9ySd5ELpQiIzNRhQjsCLbZE+cHZHeHHhcJjFM4li85eNOQTpld5gUsjRPkn3VONZu+
         IwxcRcQ4OQY3yA4O3yX6zCfDYVR+zuo6XNWEuKpEqACfGdeZjCNKyWQROn+aal7Ce0j5
         HD9wCKJRpWQbxzoBw7I+rwtSn+NtELV1YaOQdX0mcH0uyh3zpMIqIdDUKIityyaxGOrc
         8ghA==
X-Forwarded-Encrypted: i=1; AJvYcCXUFlSakHDsSMyO7FS3uljya3hDxxJY2mpGRvFT2txnJCuARVDiUo9ZmVehyKsi7bCyA3n7Iqhk6Om+TRfc@vger.kernel.org
X-Gm-Message-State: AOJu0YxbUXUjiPeA8sI+d0Yiyq/0f5oMq4XtWLJvmunjX0lGZ9UJ4oKF
	4l2VtygRRihfq7ZUMv+soXYaB3LF9lR8IyjJgrHFV7KOh+96ne0doP1lhqbCfd4=
X-Gm-Gg: ASbGncswBOIeakRgbgr/dnYWXGT3tDAGM6jvusnQREBGD+W7HFfQ5erPavH/7ib6i27
	rLTkZXJ9bfqN4eSneQjBoCiwsSLxPc0pKfa44/NZRJhy9a7fojBIrwrGyJ0stvO+z3PRMMBzQXs
	Cg7Lh1QAG5v5dzOJT39nJGyCVkAJi3weiGw8NH1Lyzs02lrSnYBxYboJ7E+5zA2E0Wq1P4JJd2K
	1/d0yHtnRA3p/f1/E+0xl+dBz6R2e89BQkxxAcM4NDxaUES/q2PZ5kpwjfiOFe2UC9VutfOOlSX
	mJ8VtDuvwhHo4UCjKqcA4I/uipCau+kAYA==
X-Google-Smtp-Source: AGHT+IFWTYnp6D/zkGSYVNm1FrSqQIpISfAHY79VVmNAFplt0tF48vwcInl3W5zDOjvns319vPabIQ==
X-Received: by 2002:a05:6000:2101:b0:390:f750:40df with SMTP id ffacd0b85a97d-390f750412amr8249016f8f.34.1741103291282;
        Tue, 04 Mar 2025 07:48:11 -0800 (PST)
Received: from pathway ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a6a9fsm18261441f8f.36.2025.03.04.07.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:48:10 -0800 (PST)
Date: Tue, 4 Mar 2025 16:48:09 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 1/2] livepatch: Add comment to clarify klp_add_nops()
Message-ID: <Z8cguQqYISkiRjnb@pathway>
References: <20250227024733.16989-1-laoar.shao@gmail.com>
 <20250227024733.16989-2-laoar.shao@gmail.com>
 <Z8B6pXGtqSYxADg1@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8B6pXGtqSYxADg1@pathway.suse.cz>

On Thu 2025-02-27 15:45:57, Petr Mladek wrote:
> On Thu 2025-02-27 10:47:32, Yafang Shao wrote:
> > Add detailed comments to clarify the purpose of klp_add_nops() function.
> > These comments are based on Petr's explanation[0].
> > 
> > Link: https://lore.kernel.org/all/Z6XUA7D0eU_YDMVp@pathway.suse.cz/ [0]
> > Suggested-by: Petr Mladek <pmladek@suse.com>
> > Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>

JFYI, I have pushed this patch into livepatching.git,
branch for-6.15/trivial.

It is a trivial patch and is independent on the other problems.

Best Regards,
Petr

