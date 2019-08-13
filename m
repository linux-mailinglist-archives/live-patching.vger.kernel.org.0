Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158868BA77
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2019 15:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfHMNg4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Aug 2019 09:36:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:56962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbfHMNg4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Aug 2019 09:36:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 787DDAD05;
        Tue, 13 Aug 2019 13:36:55 +0000 (UTC)
Date:   Tue, 13 Aug 2019 15:36:50 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] livepatch: Allow to distinguish different version
 of system state changes
In-Reply-To: <20190719074034.29761-4-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1908131534130.10477@pobox.suse.cz>
References: <20190719074034.29761-1-pmladek@suse.com> <20190719074034.29761-4-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9c8b637f17cd..bc5766f45442 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -133,10 +133,12 @@ struct klp_object {
>  /**
>   * struct klp_state - state of the system modified by the livepatch
>   * @id:		system state identifier (non zero)
> + * @version:	version of the change (non-zero)

This is inconsistent. Maybe "nonzero" in both cases (or "non-zero")?

Miroslav
