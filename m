Return-Path: <live-patching+bounces-116-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CA1825509
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 15:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7BB91F23894
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 14:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5695A2D7B6;
	Fri,  5 Jan 2024 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bDidyq/X"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9BF2D78D
	for <live-patching@vger.kernel.org>; Fri,  5 Jan 2024 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-555936e7018so1897300a12.2
        for <live-patching@vger.kernel.org>; Fri, 05 Jan 2024 06:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704464211; x=1705069011; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7U1U09z3TOeegDNy86IPlrzYZyW+9O5Q8wyI3jKg8Dc=;
        b=bDidyq/XI6By47y8ebbW5gAIQ/aNjOeKVb1DAPfdaTAS5oabqjgnELwTOZbobDQt9C
         zimJ5qIO3CjXwTsBvh0qU167AnSkuXVJOnGqliNuOPAnE2F1LcT63gZdpPw2g5Nx7k5r
         8I4+ibMw7vC5M5aeEcWSz13HTZDysY4CMHZXwiYTL+70uvEDJiJxC591Oww1z8SjnwhB
         0k9tL2qwEnT4ifjF75A5f6uvqcpM7ONZsaEZ/YIIk6if7vF339lYLC2YdxKWr0kAhME+
         j0+ccnrV0k7EQT27ctKrn14l2lbI1CsYYkPuq6oSZcbzcY6fe9GUjW1dKT7rAg3Xab01
         W+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704464211; x=1705069011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7U1U09z3TOeegDNy86IPlrzYZyW+9O5Q8wyI3jKg8Dc=;
        b=dg6Pzd3JS2aKRevv4ogZRSyU0sUzwrgVuF1CAnaFILKZaoYXIKeGr/t6FiN+dpfTQ5
         oKQXI+FxFhmuuIpcw2dYYPYFas9jyXDYoHLqZZ9Og/xbAfnvBpgQTh9MPd9O8Os53EbK
         15UjtnomZbuUo2wDqGF5WlPZesSzjxhd4hWHQTzg0AedHo2u/9JhATbmluMXgScH0gKO
         /Mo/SgTPpOdFKu2OQUU2OkBByCk2c0pwGj38PuBK8lNVw9wLUrzYONBsg53RA1ie2Njv
         iLgPATOVLsXLv5BB/0Csi9cXw5dSOG8nd7WjYqETtFF6tV1j4MUS47Ts+zgxzo+Cmx1b
         vXug==
X-Gm-Message-State: AOJu0YyYtztvKJxfuYqUdL1Px7dszIH629qLdic8fQdKWBFpfCDnOO8f
	6NLuyvVOH/AuRAnT/PkvZ34HUYO3gZ932w==
X-Google-Smtp-Source: AGHT+IEy9OpGObmTsp6Vssi6XSCxWEqxRnfpRv09W/5AOlxtpyya6zeM7WBWQZgtOU51iVS0fsbhYQ==
X-Received: by 2002:a17:906:4ad3:b0:a29:4267:ac9 with SMTP id u19-20020a1709064ad300b00a2942670ac9mr422848ejt.52.1704464210875;
        Fri, 05 Jan 2024 06:16:50 -0800 (PST)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id am19-20020a170906569300b00a26ac57b951sm926158ejc.23.2024.01.05.06.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 06:16:50 -0800 (PST)
Date: Fri, 5 Jan 2024 15:16:49 +0100
From: Petr Mladek <pmladek@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v1 5/5] documentation: Update on livepatch elf format
Message-ID: <ZZgPUSXzQBQewDFL@alley>
References: <20231106162513.17556-1-lhruska@suse.cz>
 <20231106162513.17556-6-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106162513.17556-6-lhruska@suse.cz>

On Mon 2023-11-06 17:25:13, Lukas Hruska wrote:
> Add a section to Documentation/livepatch/module-elf-format.rst
> describing how klp-convert works for fixing relocations.
> 
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

Looks good to me:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

