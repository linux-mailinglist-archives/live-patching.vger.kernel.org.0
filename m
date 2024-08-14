Return-Path: <live-patching+bounces-491-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC835951A93
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 14:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 662DA2841CB
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2024 12:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4655F1AE855;
	Wed, 14 Aug 2024 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CSW5WiCU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB631AC43D
	for <live-patching@vger.kernel.org>; Wed, 14 Aug 2024 12:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723637390; cv=none; b=sZuWkEowONeUgQoFDsPiPWJoEvMVnCFmoJFKsMljR9eZaF/4JjkXEkAiQRUpKVe95StV8Dr+3Jeu40i3yUeK5XNI/U//iwuxTcxKoZEguV/6mFoBdyQn8JPsso3mMjbinHZ7niuYgRlZkTqZIFiu+lzFZW7/OqpxNNrcYraB9v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723637390; c=relaxed/simple;
	bh=tn4995DAyVsJ3De0XVz7+XmF9zO0iObunLUXxBhv6F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUmYFFXU17JROYxYiIAykG7kIh43M7XA7KAyLsKHzgj85TJXsS3l6PKTuVvXKNLZ6224+nOOZhlmNy811BkweJLo9DnBjbZDgG3GGJSadTNXbqnEDewPRxkFRn3ik7HjUgHA3Rk8S+fH6dKQ2DeDwFywJE5OvTzty+iygSGfzl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CSW5WiCU; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7a83a968ddso662688766b.0
        for <live-patching@vger.kernel.org>; Wed, 14 Aug 2024 05:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723637385; x=1724242185; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8+OgZPrbcfevzxKpS5z7cjOxcrGutO4dpVagSt8VMo=;
        b=CSW5WiCUYPohFVsyMc3HNlRN7wjSwqp/gKFHAoBKDA8RIl/OzVVucDZhv/U7SZwt6p
         kWQ+x8wk5Me8NxAm9pWci1aE3FTmoElnmMEa6Wbnu3Dc4ov+bTLlAfZTcrsg7oTXT6sD
         QFkaYZDqBoJaD06ANS10A/d1SXkaMMYYz/7Fb7kHJdWt7tku7+HmArKidmQok6owf3X6
         /SQFVvYYIK0BAuMutDVDzKWLQ1GtxKOwaBN+e60fqPDYBHnnm3+Xj7l7mBQ2P0DfmJ1Z
         yZRb1b9WjY9Hh/pL8pgO2dPOiFDqzNNvvb6Yoc2fFGWS2eYHKNBQd2R0GTGX3LLTUMzq
         sfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723637385; x=1724242185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8+OgZPrbcfevzxKpS5z7cjOxcrGutO4dpVagSt8VMo=;
        b=iACck86vmTMMXPTeFiRek6fg8xCx7xV7jzTHw5baLNZ5WcGMy1i3mAEOxF3qEki684
         0ZlmxJ0ris6fZBr+RpPGNn8L/vFIRlDOyAvLXkeuETUCvtYBgtbSpPZO20/nrdcrOy5+
         K88H/a0nZC1Bdvcx5X6ESZbCN6KAihGbxmq2WmPtjSmlvXe4/AtU0caIHstDYsn6JQ4C
         /X6EE63Vx+h1f8T0dStjaEFGV621g9kur70kQ2RmHdcNsZYI2ep5XOAwfzUFb61BKN8L
         n/XGM92eXbSCGqR3lOWvJjyQ88WFtgA3s0RDvk+pbPssz8GPq0s4mQz1/+cIcbTvEpmv
         YClg==
X-Gm-Message-State: AOJu0YxnRbFgB+eVdxjk4Yqs66ZNrkPYllHeZCEvlSXOrsW4I0MtgOSN
	Wg+QobaEdEhxRfeKOk3CldGjezIaxoZGeiXo4ifIpXH43j+c+wo0lcumLHp+l6U=
X-Google-Smtp-Source: AGHT+IF/AQc5OsMsDO36uU4URAWXHfYH7FJV3YMENI/3lH9Cf+i/PLRvceCxirD4CDWV6m/Rt52jZQ==
X-Received: by 2002:a17:907:efe2:b0:a77:dcda:1fe1 with SMTP id a640c23a62f3a-a8366c32199mr159835466b.25.1723637385039;
        Wed, 14 Aug 2024 05:09:45 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f3fa69c3sm165813266b.55.2024.08.14.05.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 05:09:44 -0700 (PDT)
Date: Wed, 14 Aug 2024 14:09:42 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	nathan@kernel.org, morbo@google.com, justinstitt@google.com,
	mcgrof@kernel.org, thunder.leizhen@huawei.com, kees@kernel.org,
	kernel-team@meta.com, mmaurer@google.com, samitolvanen@google.com,
	mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Message-ID: <ZryehvKuUogvtYhW@pathway.suse.cz>
References: <20240807220513.3100483-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>

On Wed 2024-08-07 15:05:11, Song Liu wrote:
> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly.
> 
> Address this by sorting full symbols at build time, and let kallsyms
> lookup APIs to match the symbols exactly.

The changes look good from the livepatching POV. For both patches,
feel free to use:

Acked-by: Petr Mladek <pmladek@suse.com>

I made a quick glance over the code changes. They look sane. But I did
not check them deep enough to provide a valuable Reviewed-by ;-)

Best Regards,
Petr

