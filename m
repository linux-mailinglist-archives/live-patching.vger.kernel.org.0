Return-Path: <live-patching+bounces-884-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A659F9E943B
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 13:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE941888230
	for <lists+live-patching@lfdr.de>; Mon,  9 Dec 2024 12:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FEB22A1C5;
	Mon,  9 Dec 2024 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hD8xq5UD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97F6229B3B
	for <live-patching@vger.kernel.org>; Mon,  9 Dec 2024 12:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733747568; cv=none; b=Z9qdEesq/MLIUTI8/DwrRGQGbMDkQngdFbKFnAw0GebW99355I3W+KAG4dzjXCiGA8TmBsP3rFqsUjUPoyh/0oNsreASAvVvo/N7uC99DLkXj4UT24NeYdvk7FQLMUNJ6fcLenTya1HMuA5jON7YO2yOlMYLeQBF7EVyWLEtPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733747568; c=relaxed/simple;
	bh=ojkIf+NJwH2pcMn4s5pw7xVqm1AtSmgfJH/UKFJ2AUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czCdHnuRFvz+44G9T/mgucqqn41lJRck1T+gcnKEjRrfpNXfYDKyICJpQFW2SWcm3W3mHJSzOkJiiY2VFDhGV+bb1Sscr6OcTYe9Q9wOoH2e5ANmfOn2ZzWpJSYcdZxjaB0WShkc9rNePAViGFRQkGZTgJxNa6FV7J3Z8bXSe0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hD8xq5UD; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434f4ccddbdso13342505e9.1
        for <live-patching@vger.kernel.org>; Mon, 09 Dec 2024 04:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733747565; x=1734352365; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Njj/2vIxm5FJWzit5BXmu7RICqBEVd7qNdhzquAV+XY=;
        b=hD8xq5UDhCn6nSE0sOsojROYW8s9rftZr4s47l2KZbLXJBSe5x9sNl6h/esYwWp2EI
         9+xbNXZGqYpB7fcb23YTxA9qRQx9gX6NP7nK6Mc9TgatCCNXtunH1PcOs2jlzS+OwqPF
         8Q8KQs0/aqwBSDUbeIEpjL26wpfCRuCsGkrwvAsjHyCJDAJlk4u+jXRKyvlPlADtsaN1
         IHJCkSBYM1uxyb9dkiCPrTBLQPZV1H64Y5y+ePQpt5SmVRXNzaHsNTLVtEafKzt0DDvT
         7Ljnht58tzuinlr5dW2EG6aw6Z2MlYzgzeKij7DynpKOFSp2qpMcvCeb5+qONY1DmRd4
         4ptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733747565; x=1734352365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Njj/2vIxm5FJWzit5BXmu7RICqBEVd7qNdhzquAV+XY=;
        b=k8AQVRsPv6gig18HxBh9zGgdg/tqMBfGDUBKa2lLJLGhGgUvN7kV6kHFH4sIU1UA5H
         QIGbAVSyOuuihIcufL+ucQ6MOgtNiQthc4JiOBMhgOBTmGVrotj9fQ6Wc+ml1tLyTNCk
         PhVJY4p7T9IwU9uVCMSFY511EyStU6gllyJeI2CYnVFU03iBR4Qqs070YQwxhrBXH4BC
         bAy8NwTMxCfaxkCc1Aavked3ufJ+b9hxsmAo6IMmPzgoyIYHRY5mWGFXOQ/eLH+AY27L
         044w+cZTIEFmkJ6/XOaR9+G0blHIY0/RsOd2ehIi7AWXYch6fzkknbSJ2JLpaY0VgC8z
         2KdA==
X-Forwarded-Encrypted: i=1; AJvYcCWS0Hg2VQe7j0qktESZ9F5+7sRPL1/T/jppi/txjhkmr35/kFwg/XqNHjHnKQSDeMbDGL8ulqSeFu3if47q@vger.kernel.org
X-Gm-Message-State: AOJu0YyUbP2rYnUfwZ+XOcFq7ENWK4PW64w7mjiiGsJvxFZhRNtO1ksQ
	3Bna/l14pbym50DhTUD+KqfXFXv7bb2L7uHadRCXs959+PeZs5Hiv11J9RQeDD3viRhAu1BdHz7
	y
X-Gm-Gg: ASbGncs48b6h3v9njm027+U7ikJlZEDhexm+jCM2TYAFT6VX53ycssWrUyj52ZmrxmQ
	c9NdsjEpDMPy0PgYLvQyAlbhzEkKhGvCuU9sATwBgy/faWUOuN2WG5FscWm7ePwEdlNJoLRzisV
	yFtUciUvJIdyFY34UJN0ndPc6DujmyP9n9wvQVAHqaobXB5LqqonEAP6fhsz16M1zLiNJyl0tzp
	9Gpe6yz1AeFRzhsMgzBWlRl9GTiy2Iq4IvfmoaU/aYTeMV8hOY=
X-Google-Smtp-Source: AGHT+IHnmQQkF/LPk9+MyUY9bTIlrMV1gwhUOk65jH2TYml3ABaVJ5nzEP6I6U7EmySutmHU06Ubmw==
X-Received: by 2002:a5d:588f:0:b0:385:e37a:2a56 with SMTP id ffacd0b85a97d-3862b3e63efmr7362064f8f.52.1733747565141;
        Mon, 09 Dec 2024 04:32:45 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21628b6f47esm41089055ad.35.2024.12.09.04.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 04:32:44 -0800 (PST)
Date: Mon, 9 Dec 2024 13:32:37 +0100
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <Z1bjZbgj3JjuJZS-@pathway.suse.cz>
References: <20241024083530.58775-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024083530.58775-1-zhangwarden@gmail.com>

On Thu 2024-10-24 16:35:30, Wardenjohn wrote:
> Add selftest test cases to sysfs attribute 'stack_order'.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

JFYI, I have pushed this patch into livepatching.git,
branch for-6.14/stack-order.

Note that I have substituted /sys/kernel/livepatch with
$SYSFS_KLP_DIR. The SYSFS_KLP_DIR variable has been
introduced in 6.13.

Best Regards,
Petr

