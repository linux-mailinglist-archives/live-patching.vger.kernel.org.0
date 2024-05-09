Return-Path: <live-patching+bounces-263-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 010848C108E
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 15:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90D4BB20A12
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 13:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF1C158A3A;
	Thu,  9 May 2024 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XZxZkzZf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD791527B5
	for <live-patching@vger.kernel.org>; Thu,  9 May 2024 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715262222; cv=none; b=BtsjP+VdOksVN4e0UJSmdf1nqrfqTAepEjTDxIRSedePhWppMgQlU1UC0UCSKzKrbWlkhgOxB8vlGVM4cLp7Bv3f4I0sn/V9HNMu2Ksy/gtk9XQKatvcJJp+b+JZ+af+IGsId1Vu51NjMVXYilcVenOyLsLWcmi14M6H8Bh1xyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715262222; c=relaxed/simple;
	bh=SosXJ4ElQ643TZEOH3NiSIC1TFuDHjGhhBOhpLT9iDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkgWCqmsicZWSfAhWuSVDq6vXBq/8xi8zm8Vn+DcOi0WS31+8EUk/F0pLcvLs+uS42cYu2j+9kUOPIiS/TYpbaVgW0kXL7YvnyMUioOHmW8SK5TVnhW4jmylIQwvVA4ZlHory4i6w1a6MSbHtBEXF+SrPotLM1ktzQAgaJ+WvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XZxZkzZf; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-41b794510cdso6955025e9.2
        for <live-patching@vger.kernel.org>; Thu, 09 May 2024 06:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715262219; x=1715867019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6X3OJ4CDNvDG+N388kEs3vaDpQBTgIoXa48tqsoYMZw=;
        b=XZxZkzZfgo/6eYcqd8oEWQ1ziygNYRiDpZjm1W/f+EFLHkQwwKWBKG8Wrspap1Ewzh
         pFVG2QP29/3Si7x6+SGN5q8Y9BQo9vp6NzJUpOogQ9lXMdwIogYNmjOCLCUtsOnFsqzh
         xXkfXObakKiQ99c0RPOS9QA4BZaKtRuSTfUe9L/3NpdhW6dSun0VB1+18dESaVsRXs8a
         bRw27TSCbAFYFibDreiCx6UhqPG7JZCwker4QTcirIpcWlutaZiarHPV2i8JE459Xugb
         LADgYNvptes1l+iN/D2t1h2XAZeWG2NTym32EQlnHnkdMKRBwTS0NELmViBbceZnx190
         o7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715262219; x=1715867019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6X3OJ4CDNvDG+N388kEs3vaDpQBTgIoXa48tqsoYMZw=;
        b=OKEdwXpNejR7KJ8vjyIOcJggVqVhEISE1+rzJUIjULcIgLBbBsXKnkNsYX2BmMyPZQ
         5h+fBaCk3QWPTTOIwXDAEMM39etxjcvbEjvRncmlYR/AxmiqsNmWuBrntSJGyepMrK8v
         NOyBf2boK3u2KrnuYgqRQ6k8qbk0whyTmgNiOz+YiImoVWOCr5QnFQ5CUvdNYujYrq1Y
         jdQbjL9nztKZO5Rzh9tCZ4kq3l4vsxuzHDBR/AfoZE+QDGsziSemqlDKkT8GL/Ln/aB6
         4u6BDkVxYG3omY8Bl4i9OVYpt83iOmc+GhWT+2ZHkt+4/ZoYxlHpTiH18lONeFO0shxt
         KkSg==
X-Forwarded-Encrypted: i=1; AJvYcCW7SURobTmjnP0m1IRPdSRsugBwZK4KtqeCPdSiVYWrik8uO2/aOVeFGVEslnEnMKoj0f/y8Qv9CjXAIqfUHfLFMD9rDWoI0CuegPyweQ==
X-Gm-Message-State: AOJu0Yy/xhsYeqb2iBo0gCoNr7TYY0vS24KRvyXqaOKK8wb05dQJ3/9W
	ftS14wPQUnGgO6MQZqOw9iEybENDczC+Ea0lXGEp8O4kIYczm30O1iwgBOaRrm4=
X-Google-Smtp-Source: AGHT+IGJQsdMisyKB4MWWpNGA9ecg6F77mgAh+dcmzqub10NxvT8m5m4URuRi3BqowJD+/fsnmpqkA==
X-Received: by 2002:a05:600c:1913:b0:41a:b961:9495 with SMTP id 5b1f17b1804b1-41f719d5e9amr39625135e9.25.1715262219115;
        Thu, 09 May 2024 06:43:39 -0700 (PDT)
Received: from pathway ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502baad042sm1735897f8f.80.2024.05.09.06.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 06:43:38 -0700 (PDT)
Date: Thu, 9 May 2024 15:43:37 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhangwarden@gmail.com
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] livepatch: Rename KLP_* to KLP_TRANSITION_*
Message-ID: <ZjzTCTgaHU-Hqrqw@pathway>
References: <20240507050111.38195-1-zhangwarden@gmail.com>
 <20240507050111.38195-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507050111.38195-2-zhangwarden@gmail.com>

On Tue 2024-05-07 13:01:11, zhangwarden@gmail.com wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> The original macros of KLP_* is about the state of the transition.
> Rename macros of KLP_* to KLP_TRANSITION_* to fix the confusing
> description of klp transition state.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

JFYI, the patch has been comitted into livepatching.git, branch for-10.

Best regards,
Petr

