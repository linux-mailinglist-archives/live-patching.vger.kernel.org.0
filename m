Return-Path: <live-patching+bounces-420-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1555D9407AA
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 07:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4105A1C2221A
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 05:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7353D15ADB3;
	Tue, 30 Jul 2024 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijTW8R1g"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DE6524C;
	Tue, 30 Jul 2024 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722317825; cv=none; b=JqXWKcjvfOsl6o9ii8E0RhIulctZRulWpBpiJ+kDzSpYSsGyQkXrgAbvwIJGvG1cdz62W+4Odl1dFUCQkBUd/KxDyn0L+9N6sfMLZePOnK1+CxVJWYYWXQ+wpmgY7dsflo/9Mp3agW0nEBbO7Pv3gj6rStanIcsTGF1L1IyS71U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722317825; c=relaxed/simple;
	bh=KRszrQnUQoFtxFgqo9LOrTSnfqqtRugOvuglH2iCdok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npXD3qfliv5wRNzhoSLkCptg3ryRLtKlgdihxbYR147Zv0ZCwPbPEO6s3J5P6dvXPaXCg+MMyv4pa5UYH8tGphIpDdtkTUfeH3gcJFYCDWUJsHYS5EEFjEaHvt+zKqmhKvZqHV9Lw795ZFifvfO+NXG901ef8w94iGq+3ij1tKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijTW8R1g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBBFC4AF0E;
	Tue, 30 Jul 2024 05:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722317824;
	bh=KRszrQnUQoFtxFgqo9LOrTSnfqqtRugOvuglH2iCdok=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ijTW8R1gAxzFz4jiR7a+TDlYWcKZv2hG5Sxu4OZ46QyLNLNab76FSOuznVVHHNl0o
	 +YaIpSzUWBlv8EcQBTL5DtILcZFixfj2HfLH1Tu1l/b6bP2vJdjolVZJ8WtXU6NCEu
	 siTMQoPVwyk7El9Ch7CduYaRJDjp6MnG1TiFz/sWcanMIuBZ4kOfc7gxXE4+LxKRZ0
	 YUTfnISlqiYPtSa8ck7Jg8Aa+rRoNd1Q28jqInK4E6EbsUp44UXK3vovnw23jIVU8A
	 4qwQ0tQKkQQOYfiMMzdDlN7LEQxpg4dt+jP7QsZtLnVHeO3PsOsf5yJxywIOlS1WIv
	 F1YbPIbOLfQmQ==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52efbc57456so4388470e87.1;
        Mon, 29 Jul 2024 22:37:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXW925osYjn18zvvlUmSNqHWXrBB/mTUtw8DTZd742eH1oKtF5AN5/O9oBN7NBJTAMa1VA8FcVAOA3MQ4cbAwDbTy4nd+676xhaaIciad9uYOMDfjClOhQX99p66iylaCFQ81LMiOFNG6qXUPxdPf7e
X-Gm-Message-State: AOJu0YzWTC1sPyVD5kCU/G6Q64C/mZV1ScTwwp1o1xDYFd0lhaiHdDG6
	ky4O70tc/0eeh2b4Gb9evQoPp6ug/DN9Xp1CnB9Afh80WRfU4wyom9bfgjxxKPE0r4lopS2vYZv
	ugnQN/HU+WRkD23M0hGFD6+65aUk=
X-Google-Smtp-Source: AGHT+IGZj6ErhQ9Wobk3LKh4BFaoT/B5vA2dOc8dfQlmtWCKyrM2DWjR37r1hk53LLlIdu6v/6m8mO/qLVaSr4y6PwM=
X-Received: by 2002:ac2:4f07:0:b0:52c:e3bd:c70b with SMTP id
 2adb3069b0e04-5309b269c4amr8365653e87.1.1722317823216; Mon, 29 Jul 2024
 22:37:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730005433.3559731-1-song@kernel.org>
In-Reply-To: <20240730005433.3559731-1-song@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 29 Jul 2024 22:36:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6fXrgL-r+XRs_pVg-3XSv21pbSPcZ8djYRjcs2sHDj7g@mail.gmail.com>
Message-ID: <CAPhsuW6fXrgL-r+XRs_pVg-3XSv21pbSPcZ8djYRjcs2sHDj7g@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix kallsyms with CONFIG_LTO_CLANG
To: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, nathan@kernel.org, morbo@google.com, 
	justinstitt@google.com, mcgrof@kernel.org, thunder.leizhen@huawei.com, 
	kees@kernel.org, kernel-team@meta.com, mmaurer@google.com, 
	samitolvanen@google.com, mhiramat@kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 5:54=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly; while other users, such as kprobe, would match symbols
> without the suffix.
>
> Address this by sorting full symbols (with .llvm.<hash>) at build time, a=
nd
> split kallsyms APIs to explicitly match full symbols or without suffix.
> Specifically, exiting APIs will match symbols exactly. Two new APIs are
> added to match symbols with suffix. Use the new APIs in tracing/kprobes.

Forgot to mention: This is to follow up the discussions in this thread:

https://lore.kernel.org/live-patching/20240605032120.3179157-1-song@kernel.=
org/T/#u

Thanks,
Song

