Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06CB4E760
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2019 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFULyQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jun 2019 07:54:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:48672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbfFULyP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jun 2019 07:54:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ADF81AED9;
        Fri, 21 Jun 2019 11:54:14 +0000 (UTC)
Date:   Fri, 21 Jun 2019 13:54:13 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/5] livepatch: Selftests of the API for tracking system
 state changes
In-Reply-To: <20190611135627.15556-6-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1906211335400.5415@pobox.suse.cz>
References: <20190611135627.15556-1-pmladek@suse.com> <20190611135627.15556-6-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/lib/livepatch/test_klp_state.c b/lib/livepatch/test_klp_state.c
> new file mode 100644
> index 000000000000..c43dc2f2e01d
> --- /dev/null
> +++ b/lib/livepatch/test_klp_state.c
> @@ -0,0 +1,161 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2019 SUSE
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/printk.h>
> +#include <linux/livepatch.h>
> +
> +#define CONSOLE_LOGLEVEL_STATE 1
> +/* Version 1 does not support migration. */
> +#define CONSOLE_LOGLEVEL_STATE_VERSION 1

[...]

> +static struct klp_state states[] = {
> +	{
> +		.id = CONSOLE_LOGLEVEL_STATE,
> +		.version = 1,

s/1/CONSOLE_LOGLEVEL_STATE_VERSION/

Miroslav
