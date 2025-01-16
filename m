Return-Path: <live-patching+bounces-1002-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF44A1369A
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 10:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C62F3A69C9
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 09:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9101ACED3;
	Thu, 16 Jan 2025 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d2sSU/zx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47815197A7F
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 09:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019792; cv=none; b=mzsZOIVdXXrPwcIES70CET3kFBHKvSmON3w5lIutyCOPiCq7FOHkMZ2Nafa2w6/+joFbmpP9zaKLjH3eIqHrP1hA0/LUkqQeoA/JL47KreUmXv3iG09byyRxNlaVEJdNmxyW+ezOMCYBnhzEJVaKfTn0HDUJGbZ8CIVuBkZJwag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019792; c=relaxed/simple;
	bh=ndOQe7iYVdafaQgYnE+41A58i1xptE9OdOrBo0S9x6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLmCOSikPvYv6otm1KafwLYvuMx70XcyE2l3e93MG2AXA/PEXStatzBdirZigM7xO4NkSDANZjPlWlisTavJPcQPX9j3Ex9qIYEfVT4YKH9e5hV5TyA415JSkSosId/V3whjj14YxAhpow+UZeM8KSuCxiQ33q1By+OsufySt7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d2sSU/zx; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3862b40a6e0so399829f8f.0
        for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 01:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737019788; x=1737624588; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ndOQe7iYVdafaQgYnE+41A58i1xptE9OdOrBo0S9x6g=;
        b=d2sSU/zxhFB2TfWL9bcoZSLRQEz/Aw0/6tN3R03Lawd03W93fgwNIRTuk9i9qF7knj
         hXUWoB2gfFsMPgaiHqXGy+EuLbEpRQJEeY/jg6GV+83zruJM4IrbPFudgS/A/BqmNmIn
         qmdYlOcY4QJpVXhcPmtcIKYTcVfPsMpX5ZqlYlMBl3NICi8lbM5JV1R3B3H1lKAYumvv
         DuTwY6tF+uoTb0qfTtIOpq/nj7GtsjZGXogL7mEM44+yTvCVZS+QzCe+GSCXfSb/U8HP
         I25lRwF50lxRrs9IJs5QH4Sx6/dIA8EEulNwPeqfeRawTycbRxQJU2/6hkm6/gtcll2N
         q+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737019788; x=1737624588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndOQe7iYVdafaQgYnE+41A58i1xptE9OdOrBo0S9x6g=;
        b=Xg26dN/fYu1QvuRYoUynIDG6GEQ+DBCXOmgRCCjwbqo0EK+F4B/kVhXF5jcw9HIl90
         /aVRxdn8HmgVV+pd6T8euVXL3z82bVXoiGW7mDuzcpH65Wo6W4AvOltij7g1nV3mETgM
         y4mRhj8HqRiRbjnm9KMPA/hOkrx+o95whjNb2r8ItHd2o0YPDcI0JXqk/4x8CS+A1+HN
         uLi4iZss/sPwwViD5HrnCqEni3B2V37v4hqhDyUTsd386tsG5LHDiF2aNNe4RA+5pg1V
         CVfs3QQt3+dYmsZ4SK2sMA8AYN7PL2V25OylVGBBf0sWA02G+O0OKemZ1/3nQTx5DUx4
         KLIA==
X-Forwarded-Encrypted: i=1; AJvYcCXj/Gh/DeEJkbwOcYIzebL0ZSxAUstwcioMT8BokHk0r/XP9LDyJY71XWB7ZF33R5BasxdvieQ4b3J4ExN7@vger.kernel.org
X-Gm-Message-State: AOJu0YzzjUc5nyrncc3WB2H+RPgXY3spYr1lcjcqFqC2ReqFcd3dGk2a
	guWhI1vNH1+ZdWT5gR43defnDUN4EmBUZCj6S4w9+eEKuHIKVV/9hIzPjb3Zq6I=
X-Gm-Gg: ASbGncsqWcWtr0oOyKhHjxQK7KtrSldfIa/jpdpVPp4jnE9McAKFJp4lYqI/oOYgkzp
	h2q/hg5wda3LXrtAhqYaTy4qJfn5xT78SJHdPMoMLyfe8EYc8F/ucoqg6ms2qmCfD6RgiDutMR4
	Eky2ClWwsH+coivToh8g9pta5tC5iwg15ZKlTaLYkn2aodDJ1DUucohYNW/QAnGpyZ5cnuZXRNN
	ykX4sEVPW+I3drCw6nCy5vuRwa0EabhHn40cxUct+fZFX5JCA4vWT6rcA==
X-Google-Smtp-Source: AGHT+IH5nuIBbL7/hc99gmUbXnHjV1QmVgQbVuzI8DIlS9I/l5k+cT/NveGuMhqp+ADX/0RVXMkBfA==
X-Received: by 2002:a05:6000:4011:b0:385:f47b:1501 with SMTP id ffacd0b85a97d-38a87312d58mr26829937f8f.32.1737019788570;
        Thu, 16 Jan 2025 01:29:48 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c73e370fsm53343725e9.0.2025.01.16.01.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 01:29:48 -0800 (PST)
Date: Thu, 16 Jan 2025 10:29:46 +0100
From: Petr Mladek <pmladek@suse.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	shuah@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] selftests: livepatch: handle PRINTK_CALLER in
 check_result()
Message-ID: <Z4jRisgTXOR5-gmv@pathway.suse.cz>
References: <20250114143144.164250-1-maddy@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114143144.164250-1-maddy@linux.ibm.com>

On Tue 2025-01-14 20:01:44, Madhavan Srinivasan wrote:
> Some arch configs (like ppc64) enable CONFIG_PRINTK_CALLER, which
> adds the caller id as part of the dmesg. Due to this, even though
> the expected vs observed are same, end testcase results are failed.

CONFIG_PRINTK_CALLER is not the only culprit. We (SUSE) have it enabled
as well and the selftests pass without this patch.

The difference might be in dmesg. It shows the caller only when
the messages are read via the syslog syscall (-S) option. It should
not show the caller when the messages are read via /dev/kmsg
which should be the default.

I wonder if you define an alias to dmesg which adds the "-S" option
or if /dev/kmsg is not usable from some reason.

That said, I am fine with the patch. But I would like to better
understand and document why you need it. Also it would be nice
to update the filter format as suggested by Joe.

Best Regards,
Petr

