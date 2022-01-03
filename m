Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC47448318F
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 14:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiACNqo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 08:46:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39384 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiACNqn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 08:46:43 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4CB141F381;
        Mon,  3 Jan 2022 13:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641217602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pW7KJTe5zTu3iiMJg0fE76u+nPgBkCnt2grmEbXRLAg=;
        b=qB7TI0W/+b8yn7JSgCpj/uc/yfpA55RSQl/w+i6Lkyaf9yY2QXvRZWKTe09JM1y8Qit31j
        8mK2JVVHJIi0hhSemJNQm6Pb1I25Uub1B03aBnyxK25xG5Vis9QVOOV4Txm/XbgDiXShuE
        thVTlyZwPiV2ph+UnEaLvRW3o56zHU8=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 31687A3B81;
        Mon,  3 Jan 2022 13:46:41 +0000 (UTC)
Date:   Mon, 3 Jan 2022 14:46:41 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        void@manifault.com
Subject: Re: [PATCH -next] livepatch: Fix missing unlock on error in
 klp_enable_patch()
Message-ID: <YdL+QdAv3MtRSKJy@alley>
References: <20211225025115.475348-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211225025115.475348-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2021-12-25 10:51:15, Yang Yingliang wrote:
> Add missing unlock when try_module_get() fails in klp_enable_patch().
> 
> Fixes: bf01c2975925 ("livepatch: Fix kobject refcount bug on klp_init_patch_early failure path")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

JFYI, the patch has been committed into livepatch.git,
branch for-5.17/fixes.

Best Regards,
Petr
