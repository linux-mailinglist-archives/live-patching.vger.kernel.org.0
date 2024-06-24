Return-Path: <live-patching+bounces-361-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F33D914F12
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 15:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C42E7B2151C
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 13:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A165613E04D;
	Mon, 24 Jun 2024 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aN6qcpcE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A7413E052
	for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719236808; cv=none; b=Nm+CwsVvcbTKq7GM478X1MrLiN0Ne4Ak8KdnX22mTAfAgJL+X5lWvKGfnzZsyLJrNAG2Nv5osi5bxO2b38Fk0z0YsBaGxKd8ynVDCNuMEunpRoeu5RCM0H5PdZ2FWA7zDyQtYacjHo/Ajyxmx41Yrpdd6PpkkAH3JVOf0+8xAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719236808; c=relaxed/simple;
	bh=woQ43f/weq9Oaf3wSf5ejRZBG8ICyTh63Kh/dU1cJUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X576YCh6WALvpa2DHa2HN8URZdLiW8xSAXKO9f7DWWC16i/AeYcExViblmAv5/zW310n3SIA3tChJOVtXTa1RAzjaQ7J5CevpyK0JnMGRWFP36n1QHE6SibiUEpHhv3JGu7l31h17TAU2SZVuuRQ5F7mXhIFL6X2+TwZpLIafg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aN6qcpcE; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ec52fbb50cso22254531fa.2
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 06:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719236804; x=1719841604; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5R6E0f8w0qtYuqiPOP/8idOWt2biyPRm4xA5IbfWcfg=;
        b=aN6qcpcEOtHtbxhYccxTXGyCrfmtzVj7JYN+wq3dsG2ZTjhUE7W44Pe7OxuINHDVO/
         8iyL4tmp5tS3nkgjpcoITWgnNi+OB1/9ByR/oMdD/nNL2BwHtbJx+61wyHIzJqB88l6k
         xBKDZiaCsogxjDv+X/Euwi0tKHRaJxoC/coSaBHCteh7u/C3B8Eyanw+LMUlvvpo5peZ
         ILjhsM9ON8Fb86M6hoN0URHmYhm/Kk0ILl93IxI6oyFGzmEx2fi/Op7hxnTihlNreJsb
         2UjmvfX1phfi2ayFwzSqEvlxhQvkYuBgfPm3ob8noqBtQ+uhNzdkLabdKCdDXQKrI2XE
         IHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719236804; x=1719841604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R6E0f8w0qtYuqiPOP/8idOWt2biyPRm4xA5IbfWcfg=;
        b=FFRzYTUNoZV2UfmELe57bgLgJNDqaIvdA2A5kcF3xMcINcg5LE3qtRZwBO+/ULnMfO
         G1c8pHMmhomD8R5D4UgWLpUYwpAbLAIqYZMiREW32mQhF4Lkuh1C5Eq/2R+5phtRk4qG
         dvQmX1ZRZ4cQc77XCU3vCHqGz5l4BSRZyX87UOJpFTo9l24aJNFxfQDwCgjmhjJrEdve
         gXM8mtjB6q3WhKhvlLCnfBnT5BA7M2zBVUHYeKnrQr6hgudLsk2t04sftuMQtSfv+0/6
         aDd3YY1DHEEI8QC/xXEyrE1PkUwsjti3tfNR47O99TDRUVSP1T/63R+d4bU5Fjvc5TW+
         Jpgw==
X-Forwarded-Encrypted: i=1; AJvYcCUgCU5sVZyd+OcYz29XwxnHYTS1/cPWn8ePRBMrIGPN5sPAjUhNoHNtqS2Dbzoa5wFhmIou4mvtXXdgHbzeIq7cHTALiG2FNQtDU9PdFw==
X-Gm-Message-State: AOJu0YxNlNCQ3JybfA5lBYQorOZkDKBqQkCHAr4Aib0CwHDVQ7cqZ0cs
	B6ghzu16R/mAa0hhgOrbl6tOc6OT8rVxeo1R68G7PsFcASsX+WBKmo0H4H1OWWk=
X-Google-Smtp-Source: AGHT+IG5MeC8qHUuPZqBhvdq19l2unGK92B7iWajvYT0gWxTQTUFB52Ibo63b7tLnRx5wHaAGcT2wQ==
X-Received: by 2002:a2e:7809:0:b0:2ec:525f:d1e2 with SMTP id 38308e7fff4ca-2ec5b2840c6mr28938911fa.8.1719236804313;
        Mon, 24 Jun 2024 06:46:44 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70662ee117asm4725481b3a.211.2024.06.24.06.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 06:46:43 -0700 (PDT)
Date: Mon, 24 Jun 2024 15:46:35 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 1/3] livepatch: Add "replace" sysfs attribute
Message-ID: <Znl4u_dWfqK53G3k@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <20240610013237.92646-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610013237.92646-2-laoar.shao@gmail.com>

On Mon 2024-06-10 09:32:35, Yafang Shao wrote:
> When building a livepatch, a user can set it to be either an atomic replace
> livepatch or a non atomic replace livepatch. However, it is not easy to
> identify whether a livepatch is atomic replace or not until it actually
> replaces some old livepatches. It will be beneficial to show it directly.
>
> A new sysfs interface called 'replace' is introduced in this patch. The
> result after this change is as follows:
> 
>   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
>   0
> 
>   $ cat /sys/kernel/livepatch/livepatch-replace/replace
>   1

The description is not sufficient. It does not explain why this
information is useful.

The proposed change allows to see the replace flag only when
the livepatch is already installed. But the value does
not have any effect at this point. It has effect only when
the livepatch is being installed.

I would propose something like:

<proposal>
There are situations when it might make sense to combine livepatches
with and without the atomic replace on the same system. For example,
the livepatch without the atomic replace might provide a hotfix
or extra tuning.

Managing livepatches on such systems might be challenging. And the
information which of the installed livepatches do not use the atomic
replace would be useful.

Add new sysfs interface 'replace'. It works as follows:

   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
   0

   $ cat /sys/kernel/livepatch/livepatch-replace/replace
   1
</proposal>

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Otherwise the change looks good.

With a better description:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

