Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AE21BF629
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2020 13:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgD3LKi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Apr 2020 07:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgD3LKi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Apr 2020 07:10:38 -0400
Received: from linux-8ccs (p3EE2CE96.dip0.t-ipconnect.de [62.226.206.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00A720757;
        Thu, 30 Apr 2020 11:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588245038;
        bh=TsI/BKu4593Rcdqo2h9eyVYN7ozdDVL7qnI3d8BKDU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MajYZnwnuJZ0SVyD/k1pSZHgRImpw5nnRSW6P/xXqhY5QZ/+JDyC15wZg1g4tz6KQ
         cQbjatF9k2NZjv5y3isq/a+Y+ycEKGf96HBNBdKXjIOan8imCt7H3ED+H2mwzPPAU8
         +2anzj0vlveaQHM0xhMJHk8lGNwcw46rcm7LIwOQ=
Date:   Thu, 30 Apr 2020 13:10:33 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v4 11/11] module: Make module_enable_ro() static again
Message-ID: <20200430111032.GA4436@linux-8ccs>
References: <cover.1588173720.git.jpoimboe@redhat.com>
 <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [29/04/20 10:24 -0500]:
>Now that module_enable_ro() has no more external users, make it static
>again.
>
>Suggested-by: Jessica Yu <jeyu@kernel.org>
>Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Thanks! Since this patch is separate from the rest and it's based on
modules-next, I can just take this last patch through the modules tree.

Jessica
