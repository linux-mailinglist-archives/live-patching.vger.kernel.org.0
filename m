Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943BF34E279
	for <lists+live-patching@lfdr.de>; Tue, 30 Mar 2021 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhC3Hm3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Mar 2021 03:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhC3Hl6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Mar 2021 03:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F408561883;
        Tue, 30 Mar 2021 07:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617090118;
        bh=1U/9qxlDVdNrHyppMWZvNJxzfUK7wV+Ymcv7XAS5pUI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=PnxrPG/fzEtfcKByH6yy3Lsq7yfKTxl3EZdWvyBWM38THzpC/qWllrFGord0sjxdl
         VIx5+O5OWzkUBKXH+JD757XQIxt7+NPlRYeCjFvQAYuGDyQ0fl6OKeISXz9Y2hsXBg
         90O0JOkf8CoOB9QjKZiiky/9Q4JIrVPlRUSVkI+FeoucS5vknDfg3SWFq7ASydeGRH
         BBRST3yxgYiMNnHIa+H3q2gjaYeCabPsv98oAvKEwf1tDDmSU+d4sBC/8Rbwij3Rk8
         SRUaPRnITAdyzc3kwt1/0EhcJSePthH4bh0x8KRdOjx0KrPJSpOwN4WYDFbLBrcfLr
         QWaM5eSVxa7uQ==
Date:   Tue, 30 Mar 2021 09:41:55 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
cc:     jpoimboe@redhat.com, pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2] livepatch: Replace the fake signal sending with
 TIF_NOTIFY_SIGNAL infrastructure
In-Reply-To: <20210329132815.10035-1-mbenes@suse.cz>
Message-ID: <nycvar.YFH.7.76.2103300940510.12405@cbobk.fhfr.pm>
References: <20210329132815.10035-1-mbenes@suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 29 Mar 2021, Miroslav Benes wrote:

> Livepatch sends a fake signal to all remaining blocking tasks of a
> running transition after a set period of time. It uses TIF_SIGPENDING
> flag for the purpose. Commit 12db8b690010 ("entry: Add support for
> TIF_NOTIFY_SIGNAL") added a generic infrastructure to achieve the same.
> Replace our bespoke solution with the generic one.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Pushed out to livepatching#for-5.13/signal.

-- 
Jiri Kosina
SUSE Labs

