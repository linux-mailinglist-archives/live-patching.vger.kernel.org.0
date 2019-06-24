Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE9505CB
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2019 11:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfFXJcV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jun 2019 05:32:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbfFXJcV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jun 2019 05:32:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10828AF47;
        Mon, 24 Jun 2019 09:32:20 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/5] livepatch: Basic API to track system state changes
References: <20190611135627.15556-1-pmladek@suse.com>
        <20190611135627.15556-3-pmladek@suse.com>
Date:   Mon, 24 Jun 2019 11:32:19 +0200
In-Reply-To: <20190611135627.15556-3-pmladek@suse.com> (Petr Mladek's message
        of "Tue, 11 Jun 2019 15:56:24 +0200")
Message-ID: <87k1db49cs.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Petr Mladek <pmladek@suse.com> writes:

> ---
>  include/linux/livepatch.h | 15 +++++++++
>  kernel/livepatch/Makefile |  2 +-
>  kernel/livepatch/state.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 99 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/livepatch/state.c
>
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index eeba421cc671..591abdee30d7 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -132,10 +132,21 @@ struct klp_object {
>  	bool patched;
>  };
>  
> +/**
> + * struct klp_state - state of the system modified by the livepatch
> + * @id:		system state identifier (non zero)
> + * @data:	custom data
> + */
> +struct klp_state {
> +	int id;

Can we make this an unsigned long please? It would be consistent with
shadow variable ids and would give more room for encoding bugzilla or
CVE numbers or so.

Nicolai

> +	void *data;
> +};
> +
