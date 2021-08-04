Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41403E070B
	for <lists+live-patching@lfdr.de>; Wed,  4 Aug 2021 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbhHDR7O (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Aug 2021 13:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbhHDR7N (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Aug 2021 13:59:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A080C0613D5;
        Wed,  4 Aug 2021 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f05KDrtHywJ7ptgF5rdbcaksmjyPJirEWKVIlatL5dQ=; b=ZyInXTn6AUJn5/Nm0+ZZKIe/dw
        AIYzDU9oMm85lKCsFXkMZcLEI3tUpqtdDmQEr/f1FLo63q7sSG7yxzHzPHeamw2fd5QEIW+kizVE/
        fDQroRDkJvmQlIlm10Mc0GOZw/s7LWS4ZxHksbo+s0OelZXS17g/C50ngyawEkK0B32reP/1udCWc
        vjC/nSD4k/XHMxKDH+TYvkmSc06J3qBTIJYkOnt05eBZag/g4x+hoCcQJznJkvMmO7qxb9WP+ej82
        1RFeEdQmo8H1frJgEoOI91do5nV5KA2/btmeOW3q7NV3aZ7z3EW2idz/bF5bJUKwE7WWW6KGaxjA2
        HWFhB1mQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBLAR-00771T-Fk; Wed, 04 Aug 2021 17:58:59 +0000
Date:   Wed, 4 Aug 2021 10:58:59 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     lucas.demarchi@intel.com, linux-modules@vger.kernel.org
Cc:     live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        jeyu@kernel.org, osandov@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libkmod-module: add support for a patient module removal
 option
Message-ID: <YQrVY8Wxb026TDWN@bombadil.infradead.org>
References: <20210803202417.462197-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803202417.462197-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Aug 03, 2021 at 01:24:17PM -0700, Luis Chamberlain wrote:
> + diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
<-- snip -->
> +		ERR(mod->ctx, "%s refcnt is %ld waiting for it to become 0\n", mod->name, refcnt);

OK after running many tests with this I think we need to just expand
this so that the error message only applies when -v is passed to
modprobe, otherwise we get the print message every time, and using
INFO() doesn't cut it, given the next priority level available to
the library is LOG_INFO (6) and when modprobe -v is passed we set the
log level to LOG_NOTICE (5), so we need a new NOTICE(). I'll send a v2
with that included as a separate patch.

  Luis
