Return-Path: <live-patching+bounces-1334-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC17A7030A
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 15:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D0397A20C1
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 14:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFE22580FE;
	Tue, 25 Mar 2025 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EvGg3EJm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2F625742D
	for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742911313; cv=none; b=mBEAYNESTLkztXg0S/XhJWI2WOJU/M9be5cvWVoH8wqmDHgEov+K7+jJNuG/mhiJ8JYPXPFZrOptPPXdxZZ6ecWuMfbvAAY2jj+3DURiQLZLI3bOuwIxcNHFoctBmE22bkeamNtakggzRna7ezC0kr3rXEkZ6OSpuiebhzLSeKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742911313; c=relaxed/simple;
	bh=psQr5bXaqv0tOjTaqj05BjvMiGbCZhFimnuoyPINOKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRhXScdRURNbb5K2wgHhNH6tAa+9pcG5yXvfP5P7W2r7eY1eIRyvYX6SCcuZSFHPu4qVhCKU119x/h/grDQbXWNSlOr1hCJhlqdRIkyB86i1Y5nwgWJF2P33+TimAkl6BuKVwqeWSNKAxB4m8Z6qB6rlkCcwGx6R5wTZw5L05+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EvGg3EJm; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43948021a45so48532905e9.1
        for <live-patching@vger.kernel.org>; Tue, 25 Mar 2025 07:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742911309; x=1743516109; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=46eT+Hy4Lu4vCxbnU4yufuUurX2jV0hosCGpG1W53Qg=;
        b=EvGg3EJmXanhdEc1eWjMde1MfqHwmBhC73pvSnp34hV/+BzgK2B//LJ+5cmoJi/rvW
         NbXWAVx5mYI8TFQlE9cgVSeA2tvSTpXO3V11cysJGaXLqGleW9NWwU7MSRDKhJP82WJc
         caZfwITpdi2UpNOY4Ul7TnrYq6xzpdXXZLCzBlFSpl32AdtiCjtbFm8MtnLGGXNlkyME
         jBz2MUuZr8lu624vPEa+0UhrJncORcEjp6H1Y8ABbQcYpTB8AcwNWTKeINfl4X09D5bw
         c5LKKKn6V1z9Gc+nw7I/JCRDAn8IQhhO22SOKQVyLcHL8Go0jieQkWos2Cy0E3AEcdGr
         KGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742911309; x=1743516109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46eT+Hy4Lu4vCxbnU4yufuUurX2jV0hosCGpG1W53Qg=;
        b=TqWXklDGUsZr8gJGHEtSKnkc93mikBs7dMqe2mfydr3EZ7z5gkju/tJKxlW7c5mXTE
         lUZYDFYuary/Gjm190zR/kShucy7/XmWBaZUiGjjQEt2X728XWa4+5v+kSS3XcLtMNu8
         KpnxzpiWeGSDIIcfKYuiSWOTF4M2HRl1QJy9TcCmrnKw6IDYkTccj6VYCdbSlFKuGtus
         0rYrAsTIF1OEe7XkGWV13unlBjn9gxavcz9lrxoC6jF3ufOHMZwCzAhF9OdCW1fD+C1k
         woNbfj6Ll+VXwwcYQHq84JnC2Q+WsT6lLtFMIXrAZDs7gyXKC/LxGM4TA872cIMwJ9ye
         UOLw==
X-Forwarded-Encrypted: i=1; AJvYcCW+rlz6gHVicywEqFpBRuIne870Trlan+x/JCxvF2RpqOpbtJDWcniyiQoj31aSSjRHQkaa5pHaOo/K1zQy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwli20BGEK9f1NBVcNggbNZODz8AE3gNKu8kKVezmLKET0K7fT
	oFF72e+Pj9+aVAMltY4TLuMFp98li4rnCzRheku/J7r8Y0G154jB84naI2KBlis=
X-Gm-Gg: ASbGnct71PB2OP8ddnROI7iNyBoDWJ1khQH5dyP3jV7KpNWJYe4LOIZk51IVMXp9px9
	T/yLIYit4EjOkTRtzga0/XL9kbtR/B0EPmi6GoIBIUddFFDkqLmy7FiWd5sj6tilZCHqAxLABd5
	VbxSjfh69qkHysOrCEp9jUnrSVV5iLVreAWRg6rsAHU/JXPrnW9qJnOIMOZtEThUx2caCA/drj+
	Qe18uYmqHWatm6Aj21Ysz1a6pcjRUtEnToaDhiKro97Dd0vns3deEGYM4rfvlkxkESpZSs/H8FI
	hhlum5ITpYx7QwlMPSXi0RsstFXb2ccam0ZzzAp57l/Q
X-Google-Smtp-Source: AGHT+IFlf0RRgubk2wvjrK6UsEWwmBIygf5+sWvt5dTqY3ym64zMC9BzC9I2GK0CiClG8ELDEGN4IA==
X-Received: by 2002:a05:600c:1e8d:b0:43d:4e9:27fe with SMTP id 5b1f17b1804b1-43d509e9ea2mr160093245e9.8.1742911309209;
        Tue, 25 Mar 2025 07:01:49 -0700 (PDT)
Received: from pathway.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e65casm14025604f8f.69.2025.03.25.07.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 07:01:48 -0700 (PDT)
Date: Tue, 25 Mar 2025 15:01:47 +0100
From: Petr Mladek <pmladek@suse.com>
To: Filipe Xavier <felipeaggger@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, felipe_life@live.com
Subject: Re: [PATCH v3 0/2] selftests: livepatch: test if ftrace can trace a
 livepatched function
Message-ID: <Z-K3S4G5BtdP1Q-H@pathway.suse.cz>
References: <20250324-ftrace-sftest-livepatch-v3-0-d9d7cc386c75@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-ftrace-sftest-livepatch-v3-0-d9d7cc386c75@gmail.com>

On Mon 2025-03-24 19:50:17, Filipe Xavier wrote:
> This patchset add ftrace helpers functions and
> add a new test makes sure that ftrace can trace
> a function that was introduced by a livepatch.
> 
> Signed-off-by: Filipe Xavier <felipeaggger@gmail.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

JFYI, the patchset has been committed into livepatching.git,
branch for-6.15/ftrace-test.

I had a dilemma whether to push it for 6.15 or postpone it.
But it is a selftest and quite trivial. And it has been
reviewed by several people. And it seems to work well
so I think that we could push it for 6.15.

Best Regards,
Petr

