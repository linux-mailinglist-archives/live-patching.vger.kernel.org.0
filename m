Return-Path: <live-patching+bounces-352-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A56F290C74E
	for <lists+live-patching@lfdr.de>; Tue, 18 Jun 2024 12:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB9C21C21FDA
	for <lists+live-patching@lfdr.de>; Tue, 18 Jun 2024 10:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A581B1415;
	Tue, 18 Jun 2024 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="awkjWf5t"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6351B013F
	for <live-patching@vger.kernel.org>; Tue, 18 Jun 2024 08:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718700282; cv=none; b=blvdJ5CvrQKf1W+TWQ+2dAUYv6vbRgLuelPHPshqnDaDsFDX5nVim6ZFMTm2bGo3N4Axm3XucZDHLqwW5Rb4/wGzY2KgI/3oQrtgraEIqXsfDvWysnhwOO+f2nYLW+l7R3+vdZzKNzor0gErcXFhdhJHaAQl5AsXW3nyf6hceww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718700282; c=relaxed/simple;
	bh=mv7P4idE2zwjdwscL0C4cqMbkmN2v4Xjx6FUqbVC6iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut2S3kLOvFCA8KIdu9F7FVOZM06agTDhSE9c4KvojFlHm7HthlHjxbw4wSbUOfu45tMrQtwSHftL+dDhcqkxr5YnJs8DmR3cSEO+IpgYTlZ5tJnUSApK/0limgvF6olTw6PKIObSTY/ckPQdR/F4YQt4Fs3Sx7i82MZWoWtC23w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=awkjWf5t; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57c68682d1aso5942620a12.3
        for <live-patching@vger.kernel.org>; Tue, 18 Jun 2024 01:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718700279; x=1719305079; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nK2axCqPwPABo1otkncfWRRBuCN1IirP9neCmZ8cQvA=;
        b=awkjWf5tNE5HsTJnfNSHvDeBrnZCZM4i9oU0ur+CPrY1Dkh1XDjhpiRnn8si/QWUEv
         hJTGioQGNSLzx7PtNQp+/S/5rkER488wolEHA70EQWb64pKw/kmIpoW8t3SvZu3yUSso
         /WUIZ9ARq89zptjnRYSTmScABqqa+QLI9/9NpL5mmAoMaGtM5rRvIAojz7l17rnab5dS
         uj70QJJMowgGojxrrcHcbgicCOpEgRhtmyg12+yfympCPlGi7ZGy/I6ocgFExUrAtAie
         U6a74wkmS1RaVm+IOnHwR/QtPy/UWo5VAwqegpJDDjXKzYxOOT2IWvJLqItiy+amQedt
         pLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718700279; x=1719305079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nK2axCqPwPABo1otkncfWRRBuCN1IirP9neCmZ8cQvA=;
        b=aRbDSWTxxIOlFzq+hffI16tQhn3aLh+9Mk9iiqU9Y4zOC4B9J/fr9oMfc5hgwPSVgC
         zghIUsI5vGGkL4t8QIIyA6mOTcC9Gu0qnPQ19sZZlmqo2MMlhDmfOFHkViATtJ8kltiL
         SISIM1oQL8sCBIixJ5iXovNApnjgeGBMstltGoS8gWPD36L6y6+po23O3KNxx9Z28ig/
         pN1mlFQuRK5XPCkQ9QV8d+XjBCltyp64rQOZY6HaDl2ZDwcLaNLGQmzvXtg0WUsrFq1r
         Qv6ZsR+bqXvxC8wM1OzGLbPAfSV+5LtFmaBerwh7kk0zIwh+jHn9yQGWVt0KzLIjXEG5
         nW1g==
X-Forwarded-Encrypted: i=1; AJvYcCV+y4uL3D1694ArMMLD3T/MQ7Ya7jAi30g6zRLB68yvKtm91qHtluUSpWYQqm9II4zn1DzLtGBO0QOCELPuzUg9y0nneGUT2b/szzWmcA==
X-Gm-Message-State: AOJu0Ywa+hxwdiehRVwGKNcz9a++8J0Z59LxCj1oTFcEL6Ob4EHrnd1k
	9rrH8H+OhEMAO+bCo6jTyLMoC6M7k24sBIR5RfEUWbKhbdwrOd+2zLQvJizOLeE=
X-Google-Smtp-Source: AGHT+IF5emwzUb/jD+T+bQNWrywKXs257shi7gLMGlWOOKmQp0n5nZ4wRATqrb51OuSZuSMcaMUNGA==
X-Received: by 2002:a17:907:c713:b0:a6f:69ee:dcd2 with SMTP id a640c23a62f3a-a6f69eee6famr843958966b.57.1718700278043;
        Tue, 18 Jun 2024 01:44:38 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f9bbc2136sm31093066b.123.2024.06.18.01.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 01:44:37 -0700 (PDT)
Date: Tue, 18 Jun 2024 10:44:36 +0200
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] selftests: livepatch: Test atomic replace against
 multiple modules
Message-ID: <ZnFI4GHb4HA6BVNW@pathway.suse.cz>
References: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>

On Mon 2024-06-03 14:26:19, Marcos Paulo de Souza wrote:
> Adapt the current test-livepatch.sh script to account the number of
> applied livepatches and ensure that an atomic replace livepatch disables
> all previously applied livepatches.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
> Changes since v2:
> * Used variables to stop the name of other livepatches applied to test
>   the atomic replace. (Joe)

It might have been better to do the change in two patches. First one
would just add the "1" suffix to the one livepatch. Second patch
would extend the test.

But it is not worth another respin. I am going to push this version
(with the typo fixed).

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

