Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88FF229
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 10:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfD3Im6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 04:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfD3Im5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 04:42:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9BC92080C;
        Tue, 30 Apr 2019 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556613777;
        bh=7o7DZwJEOripkUNr9As7Pg/o4reVXy70s+lqUnjJVJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtQ3efFrzbYXBRfbiJGPj+G83y9rGU5I9w+BoXWL+C/1NJjp7OAj3dpgXe4eAuMo5
         ZKYr3jn5ysbaPvnLontEDZtEJiZGNyE9ZVuovs1rgVaqzqjJnfA2ZmzjHvMzrc3Iy8
         ytIgyUJRPe1EMlwtkGeK0i4Ugx8rmicU2JDtJqG0=
Date:   Tue, 30 Apr 2019 10:42:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
Message-ID: <20190430084254.GB11737@kroah.com>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430001534.26246-2-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 10:15:33AM +1000, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.
> 
> Add call to kobject_put() in error path of kobject_init_and_add().
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
