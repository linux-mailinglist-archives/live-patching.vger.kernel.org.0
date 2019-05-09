Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDF18CDC
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEIPWO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 11:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfEIPWO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 11:22:14 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A2D020989;
        Thu,  9 May 2019 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557415332;
        bh=aCuboc0DBEqSYwhDmmHu+oqhpDTlyXuSlUr8dAcbDY0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=xh1HvqatwMyA5VW31J8qpmiWMIpqBPbCZl9CTu9sauGcmuVqXG8C284OGylgFSV93
         HLbT5+PDleEAoKSY+C3qRbLliaSDnHzJfkJ+jKpTTXtgm4OlTeDt4B7FbLcBwhYZZH
         ehS9pr7LAdbR9fOuvT7afHMBcSJR3R6VPiHVJqqU=
Date:   Thu, 9 May 2019 17:22:09 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
cc:     jpoimboe@redhat.com, pmladek@suse.com, joe.lawrence@redhat.com,
        kamalesh@linux.vnet.ibm.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Remove stale kobj_added entries from kernel-doc
 descriptions
In-Reply-To: <20190507130815.17685-1-mbenes@suse.cz>
Message-ID: <nycvar.YFH.7.76.1905091721590.17054@cbobk.fhfr.pm>
References: <20190507130815.17685-1-mbenes@suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 7 May 2019, Miroslav Benes wrote:

> Commit 4d141ab3416d ("livepatch: Remove custom kobject state handling")
> removed kobj_added members of klp_func, klp_object and klp_patch
> structures. kernel-doc descriptions were omitted by accident. Remove
> them.

Applied to for-5.2/fixes. Thanks,

-- 
Jiri Kosina
SUSE Labs

