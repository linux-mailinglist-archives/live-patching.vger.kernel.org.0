Return-Path: <live-patching+bounces-489-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A656950F61
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 23:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41F131F23D30
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 21:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246DB1AAE1F;
	Tue, 13 Aug 2024 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IelEeAII"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D61AAE13
	for <live-patching@vger.kernel.org>; Tue, 13 Aug 2024 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723586161; cv=none; b=LttZrYILHmuQc6GZGIe9zyxg2YYc6Yt0MK48EO4IzBVYZHIoaai6g3ZlrhGjVI0haN3o4+GCNTUZcPHQuTS+EhSZpLgENVQcC2Al/IuW5/rXOQjQr3dlrYQRL51eyuYbdRaU/RifTWqxLpirxnD0Dzdtjlo4dFiiKK9rvvWJJG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723586161; c=relaxed/simple;
	bh=sYf7AubHKLRPISUz3iaN4Z/uAM0QtxXN1uvk9ImBQQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cpLMjcHiWs4KhVfK/pZCSJ5u/V8oGfZGzVmBxKtxTHFBlTxECM1TbzrUq4bFTo69dxMmP7RKgyhFVpW9oTmW3T8EC5ChSvQkzFrmx4IqP/nJ1XACCQZDI5s37wgOGH38PB92goKhVGEiCZkSoWbrqvH4gaLmnoKekWHGxc32bw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IelEeAII; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-49299323d71so2252349137.1
        for <live-patching@vger.kernel.org>; Tue, 13 Aug 2024 14:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723586158; x=1724190958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sYf7AubHKLRPISUz3iaN4Z/uAM0QtxXN1uvk9ImBQQA=;
        b=IelEeAIITogoo1SSJngz6zvknUJ23IORg0IIzoNgFQaInn6XdLBzk3zjG6skLppVPM
         gZuMdKd/IHfJezdOBdq1BSQtiDM0CLhxEcc2hgTtKMejxIffJwHmHz+xlE1l86gD4sHi
         BUt3LKrCBzkF/D5vnqjm6MpaE0ZHecrjK6xYAs0ycZG6Lnoo1AsyNMjLaSupNabxxVvT
         r6q+UU2ooXyoN/YK2K5ekvlNQVWnA1QrxZq/xIT0ubLDLqA8f74xqG9ELIcgtUovxR6j
         kRmtZf8oyWzEdk8Gc4dvAAcY/wmx13wlTJ0qiH0eT2wASvokQUYp9un55joVbGb0KRYO
         sVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723586158; x=1724190958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYf7AubHKLRPISUz3iaN4Z/uAM0QtxXN1uvk9ImBQQA=;
        b=aM+XJjyE9BuAn1ia1iKY6UP9mZCPohBgEOjUzfYHgkagxUInY/HLxzW2rVSMyGuU3m
         W4+pfMqtB+b6fGSlcSC7D6rhEMTncjAnchjm+C9jqkKMc5+VjvA2KpAuLqEQbd4M2KHK
         0RwS0yXLs+w9y7elVBNHe+Lyio51TCUYjvfRv6fOVv0G77vUI1MHbwv77fgIeJn4/HVs
         IczXSjHOP9RaTn4rpHnYXaJsybbBZMqCH1qm0wfFt9ttLPgeVvPx3tzZFszeK5fcNJ0K
         Jj9XWQbTZ6085xddEwIh9Sm48WR64+rMgUjRqc94NeTPVRcIeZJGiCZpeLiWyk4b4XIP
         DD/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVlq5BjCheW0CYYdvvjp3J6XGFFkM9x85wpz1gbdMknmHP12MRUjJdSJmx0qCjnK36HEH2XS70UHVWdyUq9ePJzFLIygPuj3OJ8allJcg==
X-Gm-Message-State: AOJu0YwlhNkbK+Vc78pV4xtdkZJsLUniLKz+OuSKXyJQrQpR9Uq3/CEG
	I18daPhUixw5LgwSFfmCxVzX3QynwTWdoSzlUn5dnJODQWAH71E6k7lP3zFuoecK383zIBUJBxA
	P3Ubcmhh/rIZOJOc7t5hVA/D8Iba672XkT8Em
X-Google-Smtp-Source: AGHT+IEQaFW6VTjl/NN5Addyayq2vESbO77ln4J7ElHigTL7AZmOrMHtx/th7RP9aYyJh8HhQcoWsHroq+JpTV9PMHI=
X-Received: by 2002:a05:6102:2ac1:b0:492:9adb:f4de with SMTP id
 ada2fe7eead31-497598af685mr1378119137.5.1723586158313; Tue, 13 Aug 2024
 14:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807220513.3100483-1-song@kernel.org> <20240813132907.e6f392ec38bcc08e6796a014@kernel.org>
 <0C1544B6-60CF-44DC-A10C-73F1504F81D1@fb.com>
In-Reply-To: <0C1544B6-60CF-44DC-A10C-73F1504F81D1@fb.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 13 Aug 2024 14:55:20 -0700
Message-ID: <CABCJKudPg+5Q3Y3H7LVa0DmN8ARati_oREVUqsLSvQpAgE5hWQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
To: Song Liu <songliubraving@meta.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, "mbenes@suse.cz" <mbenes@suse.cz>, "pmladek@suse.com" <pmladek@suse.com>, 
	"joe.lawrence@redhat.com" <joe.lawrence@redhat.com>, "nathan@kernel.org" <nathan@kernel.org>, 
	"morbo@google.com" <morbo@google.com>, "justinstitt@google.com" <justinstitt@google.com>, 
	"mcgrof@kernel.org" <mcgrof@kernel.org>, 
	"thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>, "kees@kernel.org" <kees@kernel.org>, 
	Kernel Team <kernel-team@meta.com>, "mmaurer@google.com" <mmaurer@google.com>, 
	"rostedt@goodmis.org" <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 13, 2024 at 2:20=E2=80=AFPM Song Liu <songliubraving@meta.com> =
wrote:
>
> Hi Masami,
>
> Thanks for your review and test!
>
> @Sami, could you please also review the set?

As the kernel no longer uses the Clang feature combination that was
the primary motivation for adding these kallsyms changes in the first
place, this series looks reasonable to me. Thanks for cleaning this
up!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami

