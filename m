Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D31711409
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 09:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfEBHUI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 03:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfEBHUI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 03:20:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954002085A;
        Thu,  2 May 2019 07:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556781608;
        bh=otilETRd29CkIhyLirC9XZ6k4DP9hiNq+U0b66iznaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HwZe7aQlz+VB2W8iPsolYzOeFs3Qzs9CkjaJgC1FlAuyDlFLJKyKsQ6f/yLQlJrcG
         RoSWtNoSs9al0h3vaf7tnpQcYU7Yup2VtghMxrNRgSf4f8pKULG+L2u8L8HxTUK3I1
         QWUaSCKQSsaHwKrDa5SM5TjasCIwDhM9w16cIlK8=
Date:   Thu, 2 May 2019 09:20:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Message-ID: <20190502072005.GE16247@kroah.com>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502023142.20139-4-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
> kernel-doc comments have a prescribed format.  This includes parenthesis
> on the function name.  To be _particularly_ correct we should also
> capitalise the brief description and terminate it with a period.

Ah, I didn't know that, sorry about that, my fault.  I'll take patch 2
and 3 now in my tree, thanks!

greg k-h
