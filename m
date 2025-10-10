Return-Path: <live-patching+bounces-1742-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 239FDBCBEBD
	for <lists+live-patching@lfdr.de>; Fri, 10 Oct 2025 09:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 238214E1A2F
	for <lists+live-patching@lfdr.de>; Fri, 10 Oct 2025 07:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1153823ED5B;
	Fri, 10 Oct 2025 07:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lwh8Whwv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0970722258C
	for <live-patching@vger.kernel.org>; Fri, 10 Oct 2025 07:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081434; cv=none; b=cHDG040o4MLnsSZpJcUUwNAI5ajGRPCa3+B7mXAPBx7DL8U8M2hbwVb8h6cB1Ugo/lHIGbhyVQTbHtmhQqAge/Xuc9zgSjUFsGPRF9b6pS3R3I0rvdOlIGFQWZwRc7JkItbMfIkvu6s7Dg6HF4fQXQPhLxEAHVowKLShY8xqpeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081434; c=relaxed/simple;
	bh=IkNqZDVNyA3duHS9hH3ye/gFfHu3uCgOFPAbVTvHETo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHi59JJ/loqAo88uJEz1HRiMcCkvHJ1SCDUOeRCSJJS6Xph6YSEwOjOLBjx0g+KxeHasYYX6OAe7tHJJ1gZNmtXf8u5FDo7rYyU2it2zo7Qy1bXMJgKy+sJgqB7Fov+GziEWaKNlNL5eesbvGEPTLPXOiruvexgwRY+Jo43DGW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lwh8Whwv; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso1211378f8f.2
        for <live-patching@vger.kernel.org>; Fri, 10 Oct 2025 00:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760081430; x=1760686230; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v15gcWq4DAaCwZCWaSHzLQyiwH2fsn5hdGQ6c6k6meE=;
        b=Lwh8WhwvA5CTVPbgq3G2qobOT9Y/6sdwjUJqHA8e8Anh1a3lrZWGzAfF9B8yho7N8S
         o8iVROmX6zE1N3RwerwjfUAwQ32cqCZZfWZpbsdYIgfdRK9AnD8UwN9QbumM9nIjT00q
         0VKv2nb6Wj9V92WQ3WF965euf5qAqHHmzbQuKNCqiss1mZd7anflxlwPJ5REq5gwmn9H
         zk+C1yHwlJWOeFjZ9RpDh9MNpxgutYb5VKKk7AE9zDsmqI6xsjVKFe8IAsE+VSsawvUp
         ufVZx4CBfvkA8HZ2TKlH1tmt+7MqfyjoKhSbl54NAYjndlXoeH8qJFUODHuRiW9hHwfu
         tNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760081430; x=1760686230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v15gcWq4DAaCwZCWaSHzLQyiwH2fsn5hdGQ6c6k6meE=;
        b=suWAPEg5AwvN4dBzAo2yM1+PulZ8x7JwUveUr0I78on3Dlv6jKnMw8MBBUHQC7sZ/k
         NLA3TLS/4x1iE0I1+wDLm98bc/8Zpwa2SCTkdZoHV/ISw0+vsv+eXbFmldkTV/AhFix4
         9gOCahVhBFhl0S4mjMJ5I9lwV5bOURd5fJrW+iXHr1yKhF/J8T3IKvOLieR/7CYwlwOR
         zn7Q3kjFKU+LASEYKLG6369el3K/Q7Jr0+LMCW7wlsN5cSCM6EqWhmK1lt0xaXtdaH/L
         ant9dYNly/sXcB8Lz248uuTVGdp6zJtuMOqDiI7RQT9At8dfxJ8wYAYs1hLR0MGyw4aX
         Kh3A==
X-Forwarded-Encrypted: i=1; AJvYcCV7rYtZsvnjWG95EsOy4WZ4ewHpf0bBzPBiB7V5x/15+OZ5WzSOGTqt9NuB+JGFsOXAqGoQwpmMX4Bsbs/z@vger.kernel.org
X-Gm-Message-State: AOJu0YxSQPrNs7LhsABg8TJeR7B+wzPpzZ4fLqQyERqBen3qynJ4tAj5
	fIJhdEXTcDHvD85mj6kv2LHn7Tw1qzm1YVoT2ZKtTusI7703g8wl7xcLsSo1mcOdcIM=
X-Gm-Gg: ASbGncvAU0zJlpKploxdfq2UEMH5HGp2WbRhITkP/HJZZ/XGIY80l5iJKrDcSW+BMSL
	kmQE4WNGMicbAoP+EC0QuzouVu+8hP1Y2kyXMKSSSBWaPG1w1rpXTUQpHTbhaaUfGcMvs234SBQ
	0QYTg8uzarfmOypxy7etZXeISj6fIVfHbvRgj+F7KhPtw+HE+7rHwRN6cRGyrjzKJ30OLSGu2af
	A3YhOQrUuDm4wniFQIFRGGmfbeLhC7jFI72QPHabJCoHvnnhIm9UwYuiELOnoEXkIimf8sNdmWP
	8202edeVX1zjv/6OcIsaJIktIFudn/btEc9Z5i6XHnnQK/d6z/SdhudElj6che75jjS0QtU/vPZ
	+pWtenedrKmF5yq7tv/nCdbKrFoqJVsw9Ia1kXz3SE3qO
X-Google-Smtp-Source: AGHT+IEQOAV09VUkoOCWbGZzKYDg6z/Rsf+FbBvjdD/ytp4882J0wO/VEVZmUYXCK6vwgIVG7lTv5Q==
X-Received: by 2002:a05:6000:26c2:b0:3e1:9b75:f0b8 with SMTP id ffacd0b85a97d-4266e8dc01amr6986150f8f.47.1760081430237;
        Fri, 10 Oct 2025 00:30:30 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8b31sm2754132f8f.54.2025.10.10.00.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 00:30:29 -0700 (PDT)
Date: Fri, 10 Oct 2025 09:30:27 +0200
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 00/63] objtool,livepatch: klp-build livepatch module
 generation
Message-ID: <aOi2E_8k9G1EnDzG@pathway.suse.cz>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>

On Wed 2025-09-17 09:03:08, Josh Poimboeuf wrote:
> This series introduces new objtool features and a klp-build script to
> generate livepatch modules using a source .patch as input.
> 
> This builds on concepts from the longstanding out-of-tree kpatch [1]
> project which began in 2012 and has been used for many years to generate
> livepatch modules for production kernels.  However, this is a complete
> rewrite which incorporates hard-earned lessons from 12+ years of
> maintaining kpatch.

The series seems to be in a pretty good state, ready for linux-next, ...

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

