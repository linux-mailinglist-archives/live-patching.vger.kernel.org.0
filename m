Return-Path: <live-patching+bounces-237-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6F68BC9A5
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 10:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6864C1F2262C
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 08:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3997E1420D4;
	Mon,  6 May 2024 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E+Aqj4p4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590F7136E22
	for <live-patching@vger.kernel.org>; Mon,  6 May 2024 08:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984651; cv=none; b=YaNekt6bmAMiO1qclZJXewfG7e/hEe+Djl7/9qW4fSzxjHURS9aKGwT3XkZayXP1gSaFC8YhUvu0o7PtRYzzVJQpmrG3xDTrF2E2YkTyGfoVYPuRfubCL+Vg5XTn3sbt+PNJgNEZVvs6ITAGF3bTS22g0HliQiwNBmVt5vNHjKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984651; c=relaxed/simple;
	bh=WlmeKD9rl2Rp427dzQgV7vKcZv06lyOSKT16KjABjKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6qxUrU5AWBMNO/UaOiHFjfZw5/9ZIvBQ2smpHJVm56mLhqKbJIqY8HjAFFzVRqOBznAn3z6o48iterFFzd520lxHIdbO+pBH41XNp3b4X6rldH+gKjlBt9KXNMxWhPR6cYY3UZVg0OtlW1zPFtUMq/7+T6GKA1hHMGcC1FR9ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E+Aqj4p4; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-34de61b7ca4so1167487f8f.2
        for <live-patching@vger.kernel.org>; Mon, 06 May 2024 01:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714984647; x=1715589447; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=afhrWXwI4RV8usxYlSerLXIupt6toB52OABQqb4bdK0=;
        b=E+Aqj4p4AcDCyHV4G7YXLKjEIaRQjxy8vzpRlJVhcgW4vqY0qvRzC1xRmvEywWbRyR
         nuW8/uGwx9v1u6cQzyepPyH1vPO2+YDwJCtb/zT0i6w+VM7ZKARKgJru2DN50mwJmTiE
         mP94DFbSUS/1afzpi2mcLqk0ZAAnkSdYJ2xE/hcX9JbCfeG7nvpCiZy4mgWTo7U+GrYl
         c8/BPCfmcTX7ZV6Q2TpJqXAIydAWzOAGLQCzuke1lIcByxdmyJtevnDgFzXq22UW7KwS
         4t397WKHbivCoufC1Ux3/fTNEf30zCrANFC8WDEfaV9C2TJh111Y6xJQK0cMWKh5/6s+
         crGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714984647; x=1715589447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afhrWXwI4RV8usxYlSerLXIupt6toB52OABQqb4bdK0=;
        b=GyECZzMrYzkG5JfUEhWFzc/kdysuQUht2CAlWy4LDilzIil3SLVvCnPMNKV9Iz7ey0
         Wyy1At3nXarJKDpbZtHfNyck9wDg0fHBMKS60AgN33iRMzZCbiMyp8u3p9qxmtdXI4Y4
         zYDkOWkH9vrL5Z4jMEVtLR/yMtqspKuK7x/tCfRkYOLlg2Zdt92swRtcoHa5Ai7vo/5o
         pbMlTaMTfzt09H1LljL9EtVEF2yLdOcJiRix1aCA/e+sdTzRwUipQn8pM0OKOFPHFI+S
         +k8Y7oq3oju1/meeKHuGlHolvkvT63NjExkGjrdqbhqG/NhboMNxKks+tobZ2d/Hv026
         zYhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaSGLYdHnTNGRoH7VCN9wEmJk4Hk3cfBVUskFarJDohVNAToW5L8o8P+RDPxgo2k6xz2KY+SP9Eq5y+FnKizR3mVpJa7LUwMkZnDGU5w==
X-Gm-Message-State: AOJu0Yykg+hFsDq2R2Rddllhj4cylQib08GqxJVqrDMmqCtCIDJnpjGS
	VFuYUdl/F/IbmifVCSC2cZ6mWDS5juwHPjr70vxb//BDBwuSdSkWp8w67Kd30p8=
X-Google-Smtp-Source: AGHT+IGV8NrR7pgOjUZQNfQV/VQkt+YMsq9MKLFk0tHMnITV6dwBQ9RSo42mHsdUqLmW9e2Fm0P4hg==
X-Received: by 2002:adf:f3c9:0:b0:34f:4c0:83a4 with SMTP id g9-20020adff3c9000000b0034f04c083a4mr3257323wrp.40.1714984646741;
        Mon, 06 May 2024 01:37:26 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d67ca000000b0034dcc70929dsm10082148wrw.83.2024.05.06.01.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 01:37:26 -0700 (PDT)
Date: Mon, 6 May 2024 10:37:24 +0200
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch.h: Add comment to klp transition state
Message-ID: <ZjiWxNLI3yS9nFI1@pathway.suse.cz>
References: <20240429072628.23841-1-zhangwarden@gmail.com>
 <20240505210024.2veie34wkbwkqggl@treble>
 <F3E94528-EA85-4A15-8452-EA2DE20EEB88@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F3E94528-EA85-4A15-8452-EA2DE20EEB88@gmail.com>

On Mon 2024-05-06 10:04:26, zhang warden wrote:
> 
> 
> > On May 6, 2024, at 05:00, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > 
> > On Mon, Apr 29, 2024 at 03:26:28PM +0800, zhangwarden@gmail.com wrote:
> >> From: Wardenjohn <zhangwarden@gmail.com>
> >> 
> >> livepatch.h use KLP_UNDEFINED\KLP_UNPATCHED\KLP_PATCHED for klp transition state.
> >> When livepatch is ready but idle, using KLP_UNDEFINED seems very confusing.
> >> In order not to introduce potential risks to kernel, just update comment
> >> to these state.
> >> ---
> >> include/linux/livepatch.h | 6 +++---
> >> 1 file changed, 3 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> >> index 9b9b38e89563..b6a214f2f8e3 100644
> >> --- a/include/linux/livepatch.h
> >> +++ b/include/linux/livepatch.h
> >> @@ -18,9 +18,9 @@
> >> #if IS_ENABLED(CONFIG_LIVEPATCH)
> >> 
> >> /* task patch states */
> >> -#define KLP_UNDEFINED -1
> >> -#define KLP_UNPATCHED  0
> >> -#define KLP_PATCHED  1
> >> +#define KLP_UNDEFINED -1 /* idle, no transition in progress */
> >> +#define KLP_UNPATCHED  0 /* transitioning to unpatched state */
> >> +#define KLP_PATCHED  1 /* transitioning to patched state */
> > 
> > Instead of the comments, how about we just rename them to
> > 
> >  KLP_TRANSITION_IDLE
> >  KLP_TRANSITION_UNPATCHED
> >  KLP_TRANSITION_PATCHED
> > 
> > which shouldn't break userspace AFAIK.

Great idea! It is better then nothing.

> Renaming them may be a better way as my previous patch. I would like to know why renaming KLP_*** into 
> KLP_TRANSITION_*** will not break userspace while 
> Renaming KLP_UNDEWFINED to KLP_IDLE would break the userspace.

As I already wrote in [1], both "task->patch_state == KLP_UNDEFINED"
and "KLP_IDLE" are misleading. They are not talking
about the state of the patch but about the state of the transition.

We could not rename the variables because it would break userspace.
But we could rename the state names at least.

[1] https://lore.kernel.org/r/Zg7EpZol5jB_gHH9@alley

Best Regards,
Petr

